//
//  Info_SubButtonView.swift
//  Infixel
//
//  Created by 차상진 on 10/24/23.
//

import SwiftUI

struct Info_SubButtonView: View {
    
    var cornerRadius = 18.0
    
    //---@EnviromentObject 적용 전
//    @Binding var arrowBtnState:Bool
//
//    @Binding var slideImage: SlideImage
//
//    @Binding var albumsOpen:Bool
//    @Binding var addAlbumOffset : CGFloat
//
//    @Binding var commentsOpen:Bool
//    @Binding var commentsOffset : CGFloat
    
    //---@EnviromentObject 적용 후
    @EnvironmentObject var appState: AppState
    @Binding var slideImage: SlideImage
    
    
    //info
    @State var pic_count = 0
    @State var user_nick = ""
    @State var thumbnail = ""
    
    @State var pic_result = false
    @State var pic_image_name = "pic down"
    @State var tags:[String] = []
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.1))
                        .background(.ultraThinMaterial)
                        
                    HStack {
                        //---@EnviromentObject 적용 전
                        //if arrowBtnState {
                        
                        //---@EnviromentObject 적용 후
                        if appState.infoBoxReset {
                            //버튼을 눌렀을때 들어갈 뷰
                            HStack {
                                VStack { //프로필, 닉네임 키우기
                                    VStack {
                                        AsyncImageView(imageURL: $thumbnail)
                                            .cornerRadius(200)
                                            
                                        
                                    }//VStack - 프로필 사진 확대
                                    .frame(width: 60, height: 60)
                                    .padding(.bottom, 5)
                                    .cornerRadius(200)
                        
                                    ScrollView(.horizontal, showsIndicators: false) { //닉네임(@) 나타나는 부분
                                        
                                        Text("@" + user_nick)
                                            .font(Font.custom("Bungee-Regular", size: 11))
                                            .foregroundColor(.white) // - 닉네임
                                    }
                                        
                                }//VStack - 프로필, 닉네임 확대
                                .frame(width: 70)
                                
                                VerticalLine()
                                    .stroke(Color(hexString: "404040"), lineWidth: 2)
                                    .frame(width: 2, height: 185) // - 세로선
                                
                                VStack { //사진 설명, 태그들
                                    //---@EnviromentObject 적용 전
                                    if slideImage.description.count > 25 {
                                    
                                    //---@EnviromentObject 적용 후
                                    //if appState.slideImage.description.count > 25 {
                                        ScrollView {
                                            VStack {
                                                //---@EnviromentObject 적용 전
                                              Text(slideImage.description)
                                                  .font(Font.custom("Bungee-Regular", size: 13))
                                                
                                                //---@EnviromentObject 적용 후
//                                                Text(appState.slideImage.description)
//                                                    .font(Font.custom("Bungee-Regular", size: 13))
                                                
                                                
                                            }
                                            
                                        }
                                        .padding(.top, 17)
                                        .frame(height: 120)
                                        
                                    } else {
                                        //---@EnviromentObject 적용 전
                                        Text(slideImage.description)
                                            .font(.system(size: 17))
                                            .padding(.top, 17)
                                        
                                        //---@EnviromentObject 적용 후
//                                        Text(appState.slideImage.description)
//                                            .font(.system(size: 17))
//                                            .padding(.top, 17)
                                        
                                        
                                    } // - 사진 설명글
                                    Spacer()
                                    
                                    //태그들 여기 표시
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach($tags, id: \.self) { $tag in
                                                ZStack {
                                                    
                                                Rectangle()
                                                    .frame(width: CGFloat(tag.count)*10 + 10, height: 20)
                                                    .foregroundColor(Color(hexString: "404040"))
                                                    .cornerRadius(7)
                                                Text(tag)
                                                        .font(.system(size:12))
                                                        .foregroundColor(.white)
                                                }
                                                
                                            }//ForEach
                                        }//HStack
                                        .padding(.bottom, 17)
                                    }//ScrollView
                                    //.padding(.bottom, 10)
                                    
                                }//VStack
                                .frame(width: 150)
                                .clipped()
                                .padding([.top, .bottom], 13) // - 사진 설명글, 태그
                            }//HStack
                        }//if - 펼쳐졌을때
                        else {
                            HStack {
                                VStack {
                                    AsyncImageView(imageURL: $thumbnail)
                                        .cornerRadius(200)
                                    
                                }//VStack
                                .frame(width: 25, height: 25)
                                .cornerRadius(200)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    Text("@" + user_nick)
                                        .font(Font.custom("Bungee-Regular", size: 12))
                                        .foregroundColor(.white)
                                }
                            }
                        }//else
                        
                        Spacer()
                        withAnimation {
                            
                            //---@EnviromentObject 적용 전
                        //Image(arrowBtnState ? "arrow_left" : "arrow_right")
                            
                            //---@EnviromentObject 적용 후
                        Image(appState.infoBoxReset ? "arrow_left" : "arrow_right")
                            
                                .frame(width: 10, height: 10)
                                .onTapGesture {
                                    withAnimation {
                                        
                                        //---@EnviromentObject 적용 전
                                        //arrowBtnState.toggle()
                                        
                                        //---@EnviromentObject 적용 후
                                        appState.infoBoxReset.toggle()
                                        
                                    }//withAnimation
                                }//onTapGesture
                        }//withAnimation
                    }//HStack
                    .padding([.leading, .trailing], 20)
                    
                }
                
                //---@EnviromentObject 적용 전
                //.frame(width : arrowBtnState ? geo.size.width * 0.8 : geo.size.width * 0.45, height: arrowBtnState ? 230 : 50)
                
                //---@EnviromentObject 적용 후
                .frame(width : appState.infoBoxReset ? geo.size.width * 0.8 : geo.size.width * 0.45, height: appState.infoBoxReset ? 230 : 50)
                
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                Spacer()
                
                ZStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.secondary.opacity(0.1))
                            .background(.ultraThinMaterial)
                    }
                    
                    //---@EnviromentObject 적용 전
                    //if arrowBtnState { //세로 일때
                        
                    //---@EnviromentObject 적용 후
                    if appState.infoBoxReset {
                        
                        VStack {
                            let padding = EdgeInsets(top: 8, leading:0, bottom: 8, trailing: 0)
                            let size = 23.0
                            
                            Spacer()
                            VStack {
                                
                                IconView(imageName: pic_image_name, size: size, padding: EdgeInsets(top: 9, leading:0, bottom: 2, trailing: -2)) {
                                    if pic_result { //pic이 눌러진 상태일때
                                       
                                        //서버로 pic 취소 요청
                                        let userId = UserDefaults.standard.string(forKey: "user_id")!
                                        
                                        //---@EnviromentObject 적용 전
                                        picOrNot(url_type: 2, image_id: slideImage.id, user_id: userId) { result in
                                            
                                        //---@EnviromentObject 적용 후
                                        //picOrNot(url_type: 2, image_id: appState.slideImage.id, user_id: userId) { result in
                                            
                                            if result ?? false { //취소하면 true 응답됨. 기본값은 false
                                                withAnimation {
                                                    pic_image_name = "pic down" //pic down 이미지로 변경
                                                    pic_result = false
                                                }
                                            } else { //응답된 값이 false 일때
                                                VarCollectionFile.myPrint(title: "info_SubButtonView, 188", content: "에러 발생")
                                            }
                                        }
                                        
                                    } else { //pic이 안된 상태일때
                                      
                                        //서버로 pic 요청
                                        let userId = UserDefaults.standard.string(forKey: "user_id")!
                                        
                                        //---@EnviromentObject 적용 전
                                        picOrNot(url_type: 1, image_id: slideImage.id, user_id: userId) { result in
                                            
                                        //---@EnviromentObject 적용 후
                                        //picOrNot(url_type: 1, image_id: appState.slideImage.id, user_id: userId) { result in
                                            
                                            if result ?? false { //취소하면 true 응답됨. 기본값은 false
                                                withAnimation {
                                                    pic_image_name = "pic!"
                                                    pic_result = true
                                                }
                                            } else { //응답된 값이 false 일때
                                                VarCollectionFile.myPrint(title: "info_SubButtonView, 203", content: "에러 발생")
                                            }
                                        }
                                    }
                                }
                                Text(String(pic_count)).font(.system(size: 11)).foregroundColor(.white)
                                
                            }
                            .padding(.bottom, 5)
                            VStack {
                                
                                IconView(imageName: "comments", size: size, padding: EdgeInsets(top: 9, leading:0, bottom: 2, trailing: 0)) {
                                    withAnimation {
                                        
                                        //---@EnviromentObject 적용 전
//                                        commentsOpen = true
//                                        commentsOffset = 200
                                        
                                        //---@EnviromentObject 적용 후
                                        appState.commentsOpen = true
                                        appState.commentsOffset = 200
                                        
                                    }
                                }
                                Text("56").font(.system(size: 11)).foregroundColor(.white)
                                
                            }
                            .padding(.bottom, 5)
                            
                            
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                withAnimation {
                                    
                                    //---@EnviromentObject 적용 전
//                                    albumsOpen = true
//                                    addAlbumOffset = 200
                                    
                                    //---@EnviromentObject 적용 후
                                    appState.albumsOpen = true
                                    appState.addAlbumOffset = 200
                                    
                                }
                                VarCollectionFile.myPrint(title: "info_SubButtonView - IconView, 232", content: "add album 버튼 클릭")
                            }
                            
                            
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                
                                print("+1")
                            }
                            
                            Spacer()
                            
                        }
                        .padding([.top, .bottom], 5)
                    } else { //가로 일때
                        HStack {
                            let padding = EdgeInsets(top: 0, leading:6, bottom: 0, trailing: 6)
                            let size = 21.0
                            
                            
                            
                            IconView(imageName: pic_image_name, size: size, padding: padding) {
                                if pic_result { //pic이 눌러진 상태일때
                                   
                                    //서버로 pic 취소 요청
                                    if let userId = UserDefaults.standard.string(forKey: "user_id") {
                                        
                                        //---@EnviromentObject 적용 전
                                        picOrNot(url_type: 2, image_id: slideImage.id, user_id: userId) { result in
                                            
                                        //---@EnviromentObject 적용 후
                                        //picOrNot(url_type: 2, image_id: appState.slideImage.id, user_id: userId) { result in
                                            
                                            if result ?? false { //취소하면 true 응답됨. 기본값은 false
                                                withAnimation {
                                                    pic_image_name = "pic down" //pic down 이미지로 변경
                                                    pic_result = false
                                                }
                                            }
                                        }
                                    }
                                } else { //pic이 안된 상태일때
                                  
                                    //서버로 pic 요청
                                    if let userId = UserDefaults.standard.string(forKey: "user_id") {
                                        
                                        //---@EnviromentObject 적용 전
                                        picOrNot(url_type: 1, image_id: slideImage.id, user_id: userId) { result in
                                            
                                        //---@EnviromentObject 적용 후
                                        //picOrNot(url_type: 1, image_id: appState.slideImage.id, user_id: userId) { result in
                                            
                                            if result ?? false { //취소하면 true 응답됨. 기본값은 false
                                                withAnimation {
                                                    pic_image_name = "pic!"
                                                    pic_result = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                           
                            IconView(imageName: "comments", size: size, padding: padding) {
                                withAnimation {
                                    
                                    //---@EnviromentObject 적용 전
//                                    commentsOpen = true
//                                    commentsOffset = 200
                                    
                                    //---@EnviromentObject 적용 후
                                    appState.commentsOpen = true
                                    appState.commentsOffset = 200
                                    
                                }
                            }
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                withAnimation {
                                    
                                    //---@EnviromentObject 적용 전
//                                    albumsOpen = true
//                                    addAlbumOffset = 200
                                    
                                    //---@EnviromentObject 적용 후
                                    appState.albumsOpen = true
                                    appState.addAlbumOffset = 200
                                    
                                }
                            }
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                print("+1")
                            }
                        }
                    }
                    
                }
                
                //---@EnviromentObject 적용 전
//                .frame(width: arrowBtnState ? geo.size.width * (0.95 - 0.8) : geo.size.width * (0.95 - 0.45), height: arrowBtnState ? 230 : 50)
                
                //---@EnviromentObject 적용 후
                .frame(width: appState.infoBoxReset ? geo.size.width * (0.95 - 0.8) : geo.size.width * (0.95 - 0.45), height: appState.infoBoxReset ? 230 : 50)
                
                
                //---@EnviromentObject 적용 전
                //.cornerRadius(arrowBtnState ? 16.0 : cornerRadius)
                
                //---@EnviromentObject 적용 후
                .cornerRadius(appState.infoBoxReset ? 16.0 : cornerRadius)
                
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            }//HStack
            .frame(width: geo.size.width, height: 300, alignment: .bottom)
            
            
        }//GeometryReader
        
        //---@EnviromentObject 적용 전
        .onChange(of: slideImage) { newValue in //slideImage 변수에 새로운 값이 할당 될때마다 실행됨.(사용자가 사진을 넘길때마다)
            
        //---@EnviromentObject 적용 후
        //.onChange(of: appState.slideImage) { newValue in
            
            getTags(imageId: newValue.id)
            
            pic_count = newValue.pic
            user_nick = newValue.user_nick
            thumbnail = newValue.profile_image
            
            if let userId = UserDefaults.standard.string(forKey: "user_id") {
                
                //---@EnviromentObject 적용 전
                picOrNot(url_type: 0, image_id: slideImage.id, user_id: userId) { result in
                   
                //---@EnviromentObject 적용 후
                //picOrNot(url_type: 0, image_id: appState.slideImage.id, user_id: userId) { result in
                    
                    pic_result = result ?? false
                    pic_image_name = pic_result ? "pic!" : "pic down"
                } //picOrNot
            }//if
            
        }//onChange
        .onAppear {
            if let userId = UserDefaults.standard.string(forKey: "user_id") {
                
                //---@EnviromentObject 적용 전
                picOrNot(url_type: 0, image_id: slideImage.id, user_id: userId) { result in
                    
                //---@EnviromentObject 적용 후
                //picOrNot(url_type: 0, image_id: appState.slideImage.id, user_id: userId) { result in
                    
                    pic_result = result ?? false
                    pic_image_name = pic_result ? "pic!" : "pic down"
                } //picOrNot
            }//if
            
            //---@EnviromentObject 적용 전
            pic_count = slideImage.pic
            user_nick = slideImage.user_nick
            thumbnail = slideImage.profile_image
            getTags(imageId: slideImage.id)
            
            //---@EnviromentObject 적용 후
//            pic_count = appState.slideImage.pic
//            user_nick = appState.slideImage.user_nick
//            thumbnail = appState.slideImage.profile_image
//            getTags(imageId: appState.slideImage.id)
            
            
        }//onAppear
    }
    
    
    func getTags(imageId: String) {
        guard let url = URL(string: VarCollectionFile.tagsGetURL) else {
                    print("Invalid URL")
                    return
                }

                let requestBody = ["image_id": imageId]
                let request = URLRequest.post(url: url, body: requestBody)

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
                            print(decodedResponse)
                            DispatchQueue.main.async {
                                self.tags = decodedResponse
                            }
                        } else {
                            print("Failed to decode response")
                        }
                    } else if let error = error {
                        print("HTTP request failed: \(error)")
                    }
                }.resume()
            }
    }
extension URLRequest {
    static func post(url: URL, body: [String: String]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        return request
    }
}
    
    
    
    func picOrNot(url_type: Int, image_id: String, user_id: String, completion: @escaping (Bool?) -> Void) {
        // 요청할 URL 설정
        
        var urlString = ""
        if url_type == 0 {
            urlString = VarCollectionFile.picOrNotURL
        } else if url_type == 1 {
            urlString = VarCollectionFile.picUpURL
        } else if url_type == 2 {
            urlString = VarCollectionFile.picDownURL
        }
        
        // 전송할 데이터 설정
        let params: [String: Any] = [
            "image_id": image_id,
            "user_id": user_id
        ]
        
        // URLRequest 객체 생성
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 데이터를 JSON 형식으로 변환하여 HTTPBody에 설정
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error converting data to JSON:", error)
        }
        
        // URLSession 객체 생성
        let session = URLSession.shared
        
        // URLSessionDataTask 객체 생성
        let task = session.dataTask(with: request) { (data, response, error) in
            // 에러 처리
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            // 응답 처리
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil)
                return
            }
            
            // 데이터 처리
            if let data = data {
                do {
                    // JSON 디코딩
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // 받아온 응답 데이터에서 Bool 값을 가져옴
                        if let liked = json["result"] as? Bool {
                            completion(liked) // Bool 값 전달
                        } else {
                            print("Failed to get liked value")
                            completion(nil)
                        }
                    }
                } catch {
                    print("Error decoding JSON:", error)
                    completion(nil)
                }
            }
        }
        
        // 요청 시작
        task.resume()
    }//picOrNot
   
    
    
    
    struct VerticalLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            return path
        }
    }
    
    
//View 끝


//#Preview {
//    Info_SubButtonView()
//}
