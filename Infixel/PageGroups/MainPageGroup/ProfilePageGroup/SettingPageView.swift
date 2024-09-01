//
//  SettingPageView.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI

struct SettingPageView: View {
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var notificationService: NotificationService
    
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        
        List {
            Section("계정 관리") {
                NavigationLink(destination: ProfileEditView().environmentObject(viewModel)) {
                    Text("프로필 편집")
                }
                NavigationLink(destination: ImageEditView()) {
                    Text("이미지 관리")
                }
            }
            
            Section("로그인") {
                Button("로그아웃") {
                    UserDefaults.standard.removeObject(forKey: "notifications")
                    notificationService.notifications = []
                    isLoggedIn = false
                }
                .foregroundColor(.red)
            }
        }
    }
}



struct ProfileEditView:View {
    
    @EnvironmentObject var viewModel: SettingViewModel
    @StateObject var profilePageViewModel = ProfilePageViewModel()
    
    @State private var isPickerPresented = false
    
    var body: some View {
        ScrollView() {
            
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
                
                TextField(profilePageViewModel.profileUser.user_id, text: $profilePageViewModel.profileUser.user_id)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
                HStack {
                    Text("유저 아이디")
                    Spacer()
                }
                .padding(.top, 30)
                
                TextField(profilePageViewModel.profileUser.user_at, text: $profilePageViewModel.profileUser.user_at)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
                HStack {
                    Text("소개")
                    Spacer()
                }
                .padding(.top, 30)
                
                TextField(profilePageViewModel.profileUser.description, text: $profilePageViewModel.profileUser.description)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                    .padding(.bottom, 20)
                
                
            
                
                Button(action: {
                    
                    VarCollectionFile.myPrint(title: "Setting page view", content:
                                                "\(profilePageViewModel.profileUser.user_id) \(profilePageViewModel.profileUser.user_at) \(profilePageViewModel.profileUser.description)"
                    )
                    
                    if viewModel.selectedImage != nil && viewModel.nickName != "" && viewModel.userId != "" {
                        
                        
                        
//                        viewModel.uploadAlbum(type: 2, album_id: id)
                    }
                    
                }, label: {
                    HStack {
                       Text("완료")
                        
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
            profilePageViewModel.getUserInfo(UserDefaults.standard.string(forKey: "user_id")!)
        }
    }
}

struct ImageEditView: View {
    var body: some View {
        VStack {
            
        }
    }
}



class SettingViewModel: ObservableObject {
    
    @Published var selectedImage        : UIImage? = nil
    @Published var nickName             : String   = ""
    @Published var userId               : String   = ""
    @Published var description          : String   = ""
    
    
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
        
        
    }
    
    
}

//#Preview {
//    SettingPageView(isLoggedIn: .constant(true))
//}
