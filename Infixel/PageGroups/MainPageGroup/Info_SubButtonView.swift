//
//  Info_SubButtonView.swift
//  Infixel
//
//  Created by 차상진 on 10/24/23.
//

import SwiftUI

struct Info_SubButtonView: View {
    
    
    //부모 뷰에 따라 댓글 뷰, 앨범 뷰 띄우기
    //@State var imageViewerOrNot:Bool
    
    
    
    var cornerRadius = 18.0
   
    @EnvironmentObject var appState: AppState
    @Binding var slideImage: SlideImage
    @Binding var isActive: Bool
    
    
    //info
    @State var pic_count = 0
    @State var user_nick = ""
    @State var thumbnail = ""
    
    @State var pic_result = false
    @State var pic_image_name = "pic down"
    @State var tags:[String] = []
    
    //화면 크기
    let width_ = UIScreen.main.bounds.width
    let height_ = UIScreen.main.bounds.height
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.1))
                        .background(.ultraThinMaterial)
                        
                    HStack {
                        if appState.infoBoxReset {
                            //화살표 버튼을 눌러 확대될 때 나타날 부분 ===========================================
                            HStack {
                                
                                //프로필, 닉네임 같이 있는 부분 ===================================
                                VStack {
                                    //유저 프로필 사진 확대=================================
                                    VStack {
                                        AsyncImageView(imageURL: $thumbnail)
                                            .cornerRadius(200)
                                    }
                                    .frame(width: 60, height: 60)
                                    .padding(.bottom, 5)
                                    .cornerRadius(200)
                                    //유저 프로필 사진 확대=================================
                                    
                                    //유저의 닉네임 =======================================
                                    ScrollView(.horizontal, showsIndicators: false) { //닉네임(@) 나타나는 부분
                                        
                                        Text("@" + user_nick)
                                            .font(Font.custom("Bungee-Regular", size: 11))
                                            .foregroundColor(.white) // - 닉네임
                                    }
                                    //유저의 닉네임 =======================================
                                        
                                }
                                .frame(width: 70)
                                //프로필, 닉네임 같이 있는 부분 ===================================
                                
                                
                                //프로필 사진, 닉네임 / description, tags 나누는 세로선 ============
                                VerticalLine()
                                    .stroke(Color(hexString: "404040"), lineWidth: 2)
                                    .frame(width: 2, height: 185)
                                //프로필 사진, 닉네임 / description, tags 나누는 세로선 ============
                                
                                
                                //description, tags ========================================
                                VStack {
                                    
                                    //description 부분 ================================
                                    if slideImage.description.count > 25 {
                                        ScrollView {
                                            VStack {
                                              Text(slideImage.description)
                                                  .font(Font.custom("Bungee-Regular", size: 13))
                                            }
                                            
                                        }
                                        .padding(.top, 17)
                                        .frame(height: 120)
                                    } else {
                                        Text(slideImage.description)
                                            .font(.system(size: 17))
                                            .padding(.top, 17)
                                        
                                    }
                                    Spacer()
                                    //description 부분 ================================
                                    
                                    //tags 부분 =======================================
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
                                                }//ZStack
                                                
                                            }//ForEach
                                        }//HStack
                                        .padding(.bottom, 17)
                                        
                                    }//ScrollView
                                    //.padding(.bottom, 10)
                                    //tags 부분 =======================================
                                    
                                }//VStack
                                .frame(width: 150)
                                .clipped()
                                .padding([.top, .bottom], 13) // - 사진 설명글, 태그
                                //description, tags ========================================
                                
                            }//HStack
                            //화살표 버튼을 눌러 확대될 때 나타날 부분 ===========================================
                            
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
                            .onTapGesture {
                                isActive = true
                                appState.profileUserId = slideImage.user_id
                            }
                        }//else
                        
                        Spacer()
                        withAnimation {
                            
                        Image(appState.infoBoxReset ? "arrow_left" : "arrow_right")
                            
                                .frame(width: 10, height: 10)
                                .onTapGesture {
                                    withAnimation {
                                        appState.infoBoxReset.toggle()
                                        
                                        
                                        if appState.infoBoxReset == true {
                                            getCommentCount(imageId: slideImage.id)
                                        }
                                        
                                        
                                    }//withAnimation
                                }//onTapGesture
                        }//withAnimation
                    }//HStack
                    .padding([.leading, .trailing], 20)
                    
                }//ZStack
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
                                        
                                        picOrNot(url_type: 2, image_id: slideImage.id, user_id: userId) { result in
                                            
                                            
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
                                        
                                        picOrNot(url_type: 1, image_id: slideImage.id, user_id: userId) { result in
                                            
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
                                        
                                        if appState.imageViewerOrNot {
                                            appState.commentOpen_imageViewer = true
                                            appState.commentOffset_imageViewer = 200
                                        } else {
                                        
                                            appState.commentsOpen = true
                                            appState.commentsOffset = 200
                                        }
                                        
                                        
                                    }
                                }
                                Text(String(appState.commentsCount)).font(.system(size: 11)).foregroundColor(.white)
                                
                            }
                            .padding(.bottom, 5)
                            
                            
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                withAnimation {
                                    
                                    if appState.imageViewerOrNot {
                                        appState.albumsOpen_imageViewer = true
                                        appState.addAlbumOffset_imageViewer = 200
                                    } else {
                                        appState.albumsOpen = true
                                        appState.addAlbumOffset = 200
                                    }
                                    
                                    
                                }
                            }
                            
                            
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                
                                withAnimation {
                                    if appState.imageViewerOrNot {
                                        appState.threedotsOpen_imageViewer = true
                                        appState.threedotsOffset_imageViewer = 300
                                    } else {
                                        appState.threeDotsOpen = true
                                        appState.threeDotsOffset = 300
                                    }
                                }
                                
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
                                        
                                        picOrNot(url_type: 2, image_id: slideImage.id, user_id: userId) { result in
                                            
                                            
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
                                        
                                        picOrNot(url_type: 1, image_id: slideImage.id, user_id: userId) { result in
                                            
                                            
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
                                    
                                    if appState.imageViewerOrNot {
                                        appState.commentOpen_imageViewer = true
                                        appState.commentOffset_imageViewer = 200
                                    } else {
                                        
                                        appState.commentsOpen = true
                                        appState.commentsOffset = 200
                                    }
                                    
                                    
                                }
                            }
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                withAnimation {
                                    
                                    if appState.imageViewerOrNot {
                                        appState.albumsOpen_imageViewer = true
                                        appState.addAlbumOffset_imageViewer = 200
                                    } else {
                                        appState.albumsOpen = true
                                        appState.addAlbumOffset = 200
                                    }
                                    
                                    
                                }
                            }
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                withAnimation {
                                    if appState.imageViewerOrNot {
                                        appState.threedotsOpen_imageViewer = true
                                        appState.threedotsOffset_imageViewer = 300
                                    } else {
                                        appState.threeDotsOpen = true
                                        appState.threeDotsOffset = 300
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: appState.infoBoxReset ? geo.size.width * (0.95 - 0.8) : geo.size.width * (0.95 - 0.45), height: appState.infoBoxReset ? 230 : 50)
                
                .cornerRadius(appState.infoBoxReset ? 16.0 : cornerRadius)
                
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            }//HStack
            .frame(width: geo.size.width, height: 300, alignment: .bottom)
            //.frame(width: width_, height: 300, alignment: .bottom)
            
        }//GeometryReader
        
        .onChange(of: slideImage) { newValue in //slideImage 변수에 새로운 값이 할당 될때마다 실행됨.(사용자가 사진을 넘길때마다)
            
            
            getTags(imageId: newValue.id)
            
            pic_count = newValue.pic
            user_nick = newValue.user_nick
            thumbnail = newValue.profile_image
            
            if let userId = UserDefaults.standard.string(forKey: "user_id") {
                
                picOrNot(url_type: 0, image_id: slideImage.id, user_id: userId) { result in
                   
                    
                    pic_result = result ?? false
                    pic_image_name = pic_result ? "pic!" : "pic down"
                } //picOrNot
            }//if
            
        }//onChange
        .onAppear {
            if let userId = UserDefaults.standard.string(forKey: "user_id") {
                
                picOrNot(url_type: 0, image_id: slideImage.id, user_id: userId) { result in
                    
                    
                    pic_result = result ?? false
                    pic_image_name = pic_result ? "pic!" : "pic down"
                } //picOrNot
            }//if
            
            pic_count = slideImage.pic
            user_nick = slideImage.user_nick
            thumbnail = slideImage.profile_image
            getTags(imageId: slideImage.id)
            
            
            
        }//onAppear
    }
    
    func getCommentCount(imageId: String) {
        guard let url = URL(string: VarCollectionFile.commentCountURL) else {
                    return
        }

        let requestBody = ["image_id": imageId]
        let request = URLRequest.post(url: url, body: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let numberString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if let myInt = Int(numberString) {
                        appState.commentsCount = myInt
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
        
                URLSession.shared.dataTask(with: url) { data, response, error in
                    
                }.resume()
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
//        
//        // URLSession 객체 생성
//        let session = URLSession.shared
//        
        // URLSessionDataTask 객체 생성
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
