//
//  ProfilePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct ProfileUser: Codable, Identifiable, Hashable {
    var id: String
    var user_at: String
    var user_id: String
    var pic: Int
    var follow: Int
    var follower: Int
    var description: String
    var profile_image: String
}

class ProfilePageViewModel: ObservableObject {
    @Published var profileUser:ProfileUser?
    
    
    @Published var showImageViewer = false
    
    @Published var images:[SearchSingleImage] = []
    
    
    func getMyImages() {
        guard let url = URL(string: VarCollectionFile.myImageURL) else {
            return
        }
        
        let userId = UserDefaults.standard.string(forKey: "user_id")!
        let body = ["user_id": userId]
        let request = URLRequest.post(url: url, body: body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode([SearchSingleImage].self, from: data) {
                        DispatchQueue.main.async {
                            self.images = decodedResponse
                        }
                    }
                } else if let error = error {
                    VarCollectionFile.myPrint(title: "ProfilePageView", content: error)
                } else {
                    print("Failed to send text to server")
                }
                
            }.resume()
        }
        
    }
    
    func getUserInfo(_ id: String) {
        guard let url = URL(string: VarCollectionFile.userProfileURL) else {
            return
        }
       
        let request = URLRequest.post(url: url, body: ["user_id" : id])
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, res, error in
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        if let decodeResponse = try? JSONDecoder().decode(ProfileUser.self, from: data) {
                            print(decodeResponse)
                            DispatchQueue.main.async {
                                self.profileUser = decodeResponse
                            }
                        }
                    } catch {
                        print("Decode Error : \(error)")
                    }
                }
            }.resume()
        }
    }
    
    
    
}


struct ProfilePageView: View {
    
    @Binding var isLoggedIn: Bool
    
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = ProfilePageViewModel()
    
    
    var body: some View {
            
            NavigationView {
                ZStack {
                    ProfilePageImageView(viewModel:viewModel)
                        .environmentObject(appState)
                    
                
                    VStack {
                        ProfilePageHeader(viewModel:viewModel)
                            .shadow(color: Color.black.opacity(0.5), radius: 7, x: 0, y: 5)
                        Spacer()
                        
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: SettingPageView(isLoggedIn: $isLoggedIn)) {
                                    Image("three dots")
                                    .foregroundColor(.white)
                                        .padding()
                                
                            }//NavigationLink
                        }
                        Spacer()
                            
                    }
                }
                .onAppear {
                    viewModel.getMyImages()
                }
                .sheet(isPresented: $viewModel.showImageViewer) {
                    if let selectedImage = appState.selectedImage, let selectedImageId = appState.selectedImageId {
                        ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
                    } else {
                        Text("Loading...")
                    }
                }
        }
    }
}







struct ProfilePageImageView: View {
    @StateObject var viewModel:ProfilePageViewModel
    
    @EnvironmentObject var appState: AppState
    
    
    
    
    var body: some View {
        ScrollView {
            ImageGridView(images: $viewModel.images) { imageId, imageName in
                appState.selectedImage = imageName
                appState.selectedImageId = imageId
                viewModel.showImageViewer = true
            }
        }
        .padding(.top, UIScreen.main.bounds.height * 0.1)
        .contentMargins(.top, UIScreen.main.bounds.height * 0.13)
        .contentMargins(.bottom, 40)
    }
}












struct ProfilePageHeader: View {
    
    @StateObject var viewModel:ProfilePageViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                GeometryReader { geo in
                    AsyncImage(url: URL(string: viewModel.profileUser != nil ? viewModel.profileUser!.profile_image : "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            VStack {
                                Image(systemName: "photo")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                           
                        @unknown default:
                            EmptyView()
                        }//--@switch
                    }//--@AsyncImage
                    
                }//--@GeometryReader
                .frame(width: 70, height: 70)
                .padding(.bottom, 8)
                //--@프로필_이미지
                
                
                Text(viewModel.profileUser != nil ? "@"+viewModel.profileUser!.user_at : "@")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                //--@유저_아이디
                
                
                Text(viewModel.profileUser != nil ? viewModel.profileUser!.user_id: "")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                //--@유저_닉네임
                
                
            }//--@VStack
            .frame(height: 180)
            
            //--@유저프로필_닉네임_아이디
            
//            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                
                    HStack(alignment: .bottom, spacing: 20) {
                            VStack {
                                Image("pic!")
                                    .resizable()
                                    .frame(width: 13, height: 13)
                                
                                Text(String(viewModel.profileUser != nil ? viewModel.profileUser!.pic: 0))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 60)
                        
                        
                        
                            VStack {
                                Text("Follow")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                
                                Text(String(viewModel.profileUser != nil ? viewModel.profileUser!.follow: 0))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 60)
                       
                            VStack {
                                Text("Follower")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                
                                Text(String(viewModel.profileUser != nil ? viewModel.profileUser!.follower: 0))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 60)
                    }
                    .frame(height: 40)
//                }
                
                VStack(alignment: .leading) {
                    Text(viewModel.profileUser != nil ? viewModel.profileUser!.description: "")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 40)
            }//---@VStack
            .frame(width: UIScreen.main.bounds.width * 0.6)
            Spacer()
        }//--@HStack
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
        .background(Color(.black))
        .clipShape(
            .rect(topLeadingRadius: 0, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 0)
        )
        .onAppear {
            viewModel.getUserInfo(UserDefaults.standard.string(forKey: "user_id")!)
        }
        
    }
}


struct SettingPageView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text("Setting") 
            Button("Log out") {
                isLoggedIn = false
           }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray)
    }
}




struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        var viewModel = ProfilePageViewModel()
        
          ProfilePageHeader(viewModel:viewModel)
    }
}
