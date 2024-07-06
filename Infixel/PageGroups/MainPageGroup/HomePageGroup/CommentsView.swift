//
//  CommentsView.swift
//  Infixel
//
//  Created by 차상진 on 4/17/24.
//

import SwiftUI

struct CommentsView: View {
    
    @Binding var slideImage             :   SlideImage
    @EnvironmentObject var appState     :   AppState
    
    
    @State var commentList              :   [Comment] = []
    @State var comment                  :   String = ""     //사용자가 작성하는 댓글
    @State var response_comments        :   Bool = false    //서버에서 댓글 응답 성공 플래그 변수
    @State var top_handle_height        :   CGFloat = 50
    @State var bottom_textfield_height  :   CGFloat = 70
    @State private var dragOffset       :   CGFloat = 0.0
    //@Binding var commentsOpen           :   Bool            //댓글창 열림 플래그 변수
    //@Binding var commentsOffset         :   CGFloat
    
    
    var body: some View {
        GeometryReader { geo in
                VStack {
                    VStack {
                        Rectangle() //상단 핸들 모양
                            .frame(width: 40.0, height: 10)
                            .foregroundColor(Color(hexString: "F4F2F2"))
                            .cornerRadius(20)
                            .padding([.top, .bottom], 20)
                            .gesture(DragGesture()
                               .onChanged { value in
                                   if appState.imageViewerOrNot {
                                       appState.commentOffset_imageViewer = value.translation.height + 200
                                   } else {
                                       appState.commentsOffset = value.translation.height + 200
                                       
                                   }
                                   
                               } // onChanged
                                .onEnded { value in
                                    
                                    if appState.imageViewerOrNot {
                                        if appState.commentOffset_imageViewer > 250 {
                                            appState.commentOffset_imageViewer = 1000
                                            appState.commentOpen_imageViewer = false
                                        } else if appState.commentOffset_imageViewer < 270 {
                                            appState.commentOffset_imageViewer = 200
                                            appState.commentOpen_imageViewer = true
                                        }
                                    } else {
                                        if appState.commentsOffset > 250 {
                                            appState.commentsOffset = 1000
                                            appState.commentsOpen = false
                                        } else if appState.commentsOffset < 270 {
                                            appState.commentsOffset = 200
                                            appState.commentsOpen = true
                                        }
                                    }
                                    
                                    
                                    
                                    
                                } //.onEnded
                           )// .gesture
                    }//VStack
                    .frame(width: geo.size.width, height: top_handle_height)
                    .background(.white)
                    
                    
                    ScrollView() {
                        if response_comments {
                            
                            if commentList.count > 0 {
                                ForEach($commentList) { comment in
                                    SingleCommentView(profile_image: comment.profile_image, user_name: comment.user_name, created_at: comment.created_at, content: comment.content)
                                }
                            
                            } else {
                              Text("댓글이 없습니다.")
                            }
                            
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(1)
                            
                        }
                    }//ScrollView
                    .frame(height: geo.size.height - top_handle_height - bottom_textfield_height - 200)
                    .onChange(of: appState.commentsOpen || appState.commentOpen_imageViewer) { value in
                        if value {
                            getComments(imageId: slideImage.id)
                            
                        }
                    }
                
                    
                    Divider()
                        .frame(width: geo.size.width*0.9,  height: 1)
                        .background(Color.gray)
                        .padding(10)
                    
                    VStack { //댓글 적는 부분
                        
                        HStack {
                            TextField("댓글 작성", text: $comment)
                                .background(Color.white)
                                .onReceive(comment.publisher.collect()) {
                                    comment = String($0.prefix(85))
                                }
                            
                            IconView(imageName: "Speech Bubble", size: 30, padding: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)) {
                                print("댓글 적기 버튼 클릭됨")
                                print(slideImage.id)
                                setComments(content: comment, imageId: slideImage.id)
                                commentList.append(
                                    Comment(
                                        id: "test id",
                                        created_at: dateFormatter.string(from: Date()),
                                        content: comment,
                                        user_id: UserDefaults.standard.string(forKey: "user_id")!,
                                        image_id: slideImage.id,
                                        user_name: UserDefaults.standard.string(forKey: "user_name")!,
                                        profile_image: UserDefaults.standard.string(forKey: "profile_image")!
                                    )
                                )
                                comment = ""
                            }
                            
                        }
                        .padding(10)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .padding(.bottom, 60)
                    }
                    .frame(height: bottom_textfield_height)
                    
                }//VStack
                .background(Color.white) // VStack에 배경색 설정
                .cornerRadius(40)
                .edgesIgnoringSafeArea(.all)
        }//GeometryReader
    }//body
    
    
    
    
    func getComments(imageId:String) {
        
        guard let url = URL(string: VarCollectionFile.commentGetURL) else {
                    print("Invalid URL")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                let body: [String: Any] = ["image_id": imageId]
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let decodedResponse = try? JSONDecoder().decode([Comment].self, from: data) {
                            DispatchQueue.main.async {
                                self.commentList = decodedResponse
                                response_comments = true
                            }
                        } else {
                            print("JSON Decoding failed")
                        }
                    } else if let error = error {
                        print("HTTP Request Failed \(error)")
                    }
                }.resume()
    }//func reqComments
    
    
    
    func setComments(content:String, imageId:String) {
        guard let url = URL(string: VarCollectionFile.commentSetURL) else {
            print("Invalid URL")
            return
        }
        
        let jsonObject: [String: Any] = [
               "content": content,
               "image_id": imageId,
               "user_id": UserDefaults.standard.string(forKey: "user_id")!
           ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                print("Failed to encode JSON")
                return
            }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error during URLSession: \(error.localizedDescription)")
                    return
                }
                
                // 성공 처리 로직 (예: 응답 데이터 출력)
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response data: \(responseString)")
                    
                }
            }.resume()
        
    }//func setComments
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter
        }

    
}
