//
//  SettingPageView.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI


struct SettingPageView: View {
    @Binding var isLoggedIn: Bool
    @State var isActive = false
    
    
    @State var disableUserPressed = false
    
    @EnvironmentObject var notificationService: NotificationService
    @EnvironmentObject var profilePageViewModel: ProfilePageViewModel
    
    @StateObject var viewModel = SettingViewModel()
    @StateObject var snsLoginViewModel = SNSLoginViewModel()
    
    
    
    
    
    var body: some View {
        
        List {
            Section("계정 관리") {
                NavigationLink(
                    destination: ProfileEditView().environmentObject(viewModel),
                    isActive: $isActive,
                    label: {
                        Text("프로필 편집")
                    }
                )
                .onChange(of: viewModel.viewDissmiss) { newValue in
                    print("viewDissmiss changed: \(newValue)") // 상태 변경 시 콘솔 로그 출력
//                    if newValue {
                        isActive = false
//                    }
                }
                
                NavigationLink(
                    destination: ImageEditView().environmentObject(profilePageViewModel)
                ) {
                    Text("이미지 관리")
                }
            }
            
            Section("로그인") {
                Button("로그아웃") {
                    UserDefaults.standard.removeObject(forKey: "notifications")
                    UserDefaults.standard.removeObject(forKey: "user_id")
                    notificationService.notifications = []
                    
                    snsLoginViewModel.kakaoLogout()
                    
                    isLoggedIn = false
                }
                
                Button("계정 삭제") {
                    disableUserPressed = true
                }
                .foregroundColor(.red)
                .alert(isPresented: $disableUserPressed) {
                    let defaultButton = Alert.Button.default(Text("삭제"), action: {
                        UserDefaults.standard.removeObject(forKey: "notifications")
                        notificationService.notifications = []
                        
                        isLoggedIn = false
                        snsLoginViewModel.disableUser()
                        
                    })
                    let cancelButton = Alert.Button.cancel(Text("취소"))
                    
                    return Alert(title: Text("계정 삭제") , message: Text("업로드한 이미지, 작성한 댓글, 생성한 앨범 모두 삭제됩니다. 계정을 삭제하시겠습니까?"), primaryButton: defaultButton, secondaryButton: cancelButton)
                }
            }
        }
        .onAppear {
            profilePageViewModel.getMyImages(UserDefaults.standard.string(forKey: "user_id")!)
        }
    }
}



struct ProfileEditView:View {
    
    @EnvironmentObject var viewModel: SettingViewModel
    @StateObject var profilePageViewModel = ProfilePageViewModel()
    
    @State private var isPickerPresented = false
    
    @State var nick_name: String = ""
    @State var user_id: String = ""
    @State var description: String = ""
    
    var body: some View {
        ScrollView {
            
            Text("프로필 수정")
                .font(Font.custom("Bungee-Regular", size: 20))
                .fontWeight(.black)
                .padding(.bottom, 30)
                .padding(.top, 20)
            
            HStack {
                Text("프로필 이미지")
                
                Spacer()
            }
            .padding(.bottom, 5)
            
            if let selectedImage = viewModel.selectedImage {
                
                ZStack {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.black.opacity(0.5)))
                                .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3)
                        )
                        .onTapGesture {
                            isPickerPresented.toggle()
                        }
                        .padding(.bottom, 30)
                    
                    
                    
                    Text("이미지 선택")
                        .foregroundColor(.white)
                }
                
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hexString: "F0F0F0"))
                            .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3) // 필요시 경계선 설정
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 200, height: 200)
                        
                        Text("Loading...")
                            .foregroundColor(Color(hexString: "4657F3"))
                    }
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                }//VStack
                .padding(.bottom, 30)
            } //else
            
            VStack(spacing: 0) {
                HStack {
                    Text("사용자 닉네임")
                    Spacer()
                }
                
                TextField(profilePageViewModel.profileUser.user_id, text: $nick_name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
                HStack {
                    Text("유저 아이디")
                    Spacer()
                }
                .padding(.top, 30)
                
                TextField(profilePageViewModel.profileUser.user_at, text: $user_id)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
                HStack {
                    Text("소개")
                    Spacer()
                }
                .padding(.top, 30)
                
                TextField(profilePageViewModel.profileUser.description, text: $description)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                    .padding(.bottom, 20)
                
                
            
                Button(action: {
                    
                    if viewModel.selectedImage != nil &&
                        profilePageViewModel.profileUser.user_id != "" &&
                        profilePageViewModel.profileUser.user_at != "" &&
                        profilePageViewModel.profileUser.description != "" {
                        
                        viewModel.update_profile(nick_name: nick_name == "" ? profilePageViewModel.profileUser.user_id : nick_name, user_id: user_id == "" ? profilePageViewModel.profileUser.user_at : user_id, description: description == "" ? profilePageViewModel.profileUser.description : description)
                    }
                    
                }, label: {
                    HStack {
                        if viewModel.uploadStatus == "" {
                            Text("완료")
                        } else {
                            Text(viewModel.uploadStatus)
                        }
                        
                    }
                    .contentShape(RoundedRectangle(cornerSize: CGSize(width: 60, height: 20)))
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 30, alignment: .center)
                })
                .disabled(viewModel.selectedImage == nil && viewModel.nickName == "" && viewModel.userId != "")
                .buttonStyle(.borderedProminent)
                .tint(Color(hexString: "4657F3"))
                .padding(.bottom, UIScreen.main.bounds.height * 0.05 + 50)
                
            }//vstack
            
             
        }//VStack
        .padding([.trailing, .leading], 20)
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .onAppear {
            viewModel.getProfileImage()
            profilePageViewModel.getUserInfo(UserDefaults.standard.string(forKey: "user_id")!, UserDefaults.standard.string(forKey: "user_id")!)
        }
    }
}

struct ImageEditView: View {
    @EnvironmentObject var profilePageViewModel: ProfilePageViewModel
    @StateObject var viewModel = SettingViewModel()
    
    
    @State var images:[SearchSingleImage] = [
//        SearchSingleImage(id: "imageid-0af2a042-ffb3-4af1-85ee-f0055cea3463", image_name: VarCollectionFile.resjpgURL+"1720457439591-723102026.jpg"),
//        SearchSingleImage(id: "imageid-1468df05-2afd-43dd-ad0b-874051c6aa52", image_name: VarCollectionFile.resjpgURL+"1721224289969-143531506.jpg"),
//        SearchSingleImage(id: "imageid-156fbb93-e780-409b-82a7-a24c20b81507", image_name: VarCollectionFile.resjpgURL+"1721743781019-5213728.jpg")
    ]
    
    @State var selectedImageId:String = ""
    @State var isShowAlert: Bool = false
    
    var body: some View {
        ScrollView {
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(images, id: \.id) { image_ in
                    GeometryReader { geo in
                    
                        Group {
                            AsyncImage(url: URL(string : image_.image_name)) { phase in
                                switch phase {
                                case .empty:
                                    Spacer()
                                    ProgressView() // 이미지를 로드 중일 때 표시할 로딩 화면
                                    Spacer()
                                case .success(let image):
                                    
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                selectedImageId = image_.id
                                                VarCollectionFile.myPrint(title: "선택된 이미지", content: image_.id)
                                                isShowAlert = true
                                            }
                                        }
                                    
                                    
                                    
                                    
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    Text("Unknown state") // 알 수 없는 상태 처리
                                }
                            }
                            .frame(width: geo.size.width, height: 300)
                            .cornerRadius(10)
                            .clipped()
                        }
                        //                    .onAppear {
//                        if case .empty = phase {
//                            viewModel.loadImage()
//                        }
//                    }
                    }
                    .frame(height: 300)
                    
                    
                }
            }//LazyVGrid
            .padding(.horizontal, 10)
            .alert(isPresented: $isShowAlert) {
                let defaultButton = Alert.Button.default(Text("삭제"), action: {
                    viewModel.deleteImage(selectedImageId)
                    
                    print("선택된 이미지 ID: \(selectedImageId)")
                    withAnimation {
                        self.images.removeAll { $0.id == selectedImageId }
                    }
                    print("After delete:", images.map { $0.id })
                    
                })
                let cancelButton = Alert.Button.cancel(Text("취소"))
                
                return Alert(title: Text("이미지 삭제") , message: Text("삭제하시겠습니까?"), primaryButton: defaultButton, secondaryButton: cancelButton)
            }//alert
        }//ScrollView
//        .padding(.top, 30)
        .contentMargins(.bottom, 90)
        .contentMargins(.top, 30)
        .onAppear {
            profilePageViewModel.getMyImages(UserDefaults.standard.string(forKey: "user_id")!)
            
            self.images = profilePageViewModel.images
            
        }
        
        
    }
}




class SettingViewModel: ObservableObject {
    
    @Published var selectedImage        : UIImage? = nil
    @Published var nickName             : String   = ""
    @Published var userId               : String   = ""
    @Published var description          : String   = ""
    
    @Published var uploadStatus         : String   = ""
    @Published var viewDissmiss         : Bool     = false
    
    
    func getProfileImage() {
        guard let url = URL(string: VarCollectionFile.getProfileImageURL) else {
            return
        }
            
        let request = URLRequest.post(url: url, body: ["user_id": UserDefaults.standard.string(forKey: "user_id")!])
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            URLSession.shared.dataTask(with: request) { data, res, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                if let data = data {
                    do {
                        // 먼저 JSON을 디코딩하여 "image" 필드를 추출
                        let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
                        
                        if let base64String = jsonResponse["image"], let imageData = Data(base64Encoded: base64String) {
                            // Base64 문자열을 Data로 변환한 후 UIImage로 변환
                            let image = UIImage(data: imageData)
                            
                            DispatchQueue.main.async {
                                self.selectedImage = image
                            }
                        } else {
                            print("Failed to decode Base64 string")
                        }
                    } catch {
                        print("Failed to decode JSON: \(error)")
                    }
                }

            }.resume()
        }
    }// getProfileImage()
    
    func updateProfile(nick_name:String, user_id:String, description:String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        VarCollectionFile.myPrint(title: "updateProfile", content: nick_name + " " + user_id + " " + description)
        
        let id = UserDefaults.standard.string(forKey: "user_id")!
        
        
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        
        guard let url = URL(string: VarCollectionFile.updateProfileURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(selectedImage.jpegData(compressionQuality: 0.8)!)
            data.append("\r\n".data(using: .utf8)!)

            // nick_name 필드 추가
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"nick_name\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(nick_name)\r\n".data(using: .utf8)!)
        
            // id 필드 추가
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"id\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(id)\r\n".data(using: .utf8)!)

            // user_id 필드 추가
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(user_id)\r\n".data(using: .utf8)!)

            // description 필드 추가
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(description)\r\n".data(using: .utf8)!)

            // 마지막 boundary
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let responseData = responseData else {
                completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: responseData)
                completion(.success(uploadResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }//updateProfile
    
    func update_profile(nick_name:String, user_id:String, description:String) {
        
        print("update_profile 1 \(self.viewDissmiss)")
        
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        
        self.updateProfile(nick_name: nick_name, user_id: user_id, description: description) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case.success(let response):
                        self?.uploadStatus = response.message
                        withAnimation {
                            self!.viewDissmiss = true
                        }
                    
                    case .failure(let error):
                    self?.uploadStatus = "업로드 실패"
                    withAnimation {
                        self!.viewDissmiss = true
                    }
                    print("update_profile 2 \(self!.viewDissmiss)")
                }
            }
            
        }
    }//update_profile
    
    
    func deleteImage(_ imageId:String) {
        guard let url = URL(string: VarCollectionFile.deleteImageURL) else {
            return
        }
        
        let request = URLRequest.post(url: url, body: ["image_id" : imageId])
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            URLSession.shared.dataTask(with: request) { data, res, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let result = json["message"] as? String {
                                VarCollectionFile.myPrint(title: "deleteImage - response", content: result)
                            }
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                }
                
                
            }.resume()
        }
        
        
    }
    
    
    
}

//#Preview {
//    SettingPageView(isLoggedIn: .constant(true))
//}
