//
//  ProfilePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI


//--@dProfileUser--------------------------------------------------------------------------------------------------------
struct ProfileUser: Codable, Identifiable, Hashable {
    var id: String = ""
    var user_at: String = ""
    var user_id: String = ""
    var pic: Int = 0
    var follow: Int = 0
    var follower: Int = 0
    var description: String = ""
    var profile_image: String = ""
}
//--@--------------------------------------------------------------------------------------------------------------




class ProfilePageViewModel: ObservableObject {
    @Published var profileUser:ProfileUser = ProfileUser()
    @Published var images:[SearchSingleImage] = []
    @Published var showImageViewer = false
    @Published var followBtn:Bool = false
    @Published var myProfileOrNot = false
    
    func getMyImages(_ id:String) {
        guard let url = URL(string: VarCollectionFile.myImageURL) else {
            return
        }
        
        let body = ["user_id": id]
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
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            URLSession.shared.dataTask(with: request) { data, res, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error : \(error)")
                    return
                }
                if let data = data {
                    do {
                        if let decodeResponse = try? JSONDecoder().decode(ProfileUser.self, from: data) {
//                            print(decodeResponse)
                            DispatchQueue.main.async {
                                self.profileUser = decodeResponse
                                if let userId = UserDefaults.standard.string(forKey: "user_id"), self.profileUser.id == userId {
                                    self.myProfileOrNot = true
                                } else {
                                    self.followOrNot(self.profileUser.id)
                                }
                            }
                        }
                    } catch {
                        print("Decode Error : \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func follow(_ follow_user_id:String) {
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        
        guard let url = URL(string: VarCollectionFile.followURL) else {
            return
        }
        
        let json:[String: String] = [
            "user_id":user_id,
            "follow_user_id":follow_user_id
        ]
        
        let request = URLRequest.post(url: url, body: json)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) {data, res, error in
                if let error = error {
                    return
                }
                if let resData = data, let resString = String(data: resData, encoding: .utf8) {
                    VarCollectionFile.myPrint(title: "follow()", content: resString)
                }
                
            }.resume()
        }
    }
    
    func unfollow(_ unfollow_user_id:String) {
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        
        guard let url = URL(string: VarCollectionFile.unfollowURL) else {
            return
        }
        
        let json:[String: String] = [
            "user_id":user_id,
            "unfollow_user_id":unfollow_user_id
        ]
        
        let request = URLRequest.post(url: url, body: json)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, res, error in
                if let error = error {
                    return
                }
                if let resData = data, let resString = String(data: resData, encoding: .utf8) {
                    VarCollectionFile.myPrint(title: "unfollow()", content: resString)
                }
                
            }.resume()
        }
    }
    
    func followOrNot(_ follow_user_id:String) {
        VarCollectionFile.myPrint(title: "followOrNot()", content: follow_user_id)
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        
        guard let url = URL(string: VarCollectionFile.followOrNotURL) else {
            return
        }
        
        let json:[String:String] = [
            "user_id": user_id,
            "follow_user_id": follow_user_id
        ]
        
        let request = URLRequest.post(url: url, body: json)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) {data, res, error in
                if let error = error {
                    VarCollectionFile.myPrint(title: "followOrNot() - error", content: error)
                    return
                }
                if let data = data,
                    let resString = String(data:data,encoding: .utf8),
                   let resData = resString.data(using: .utf8),
                   let resValue = try? JSONDecoder().decode(Bool.self, from: resData)
                {
                    VarCollectionFile.myPrint(title: "followOrNot() - result", content: resValue)
                    DispatchQueue.main.async {
                        self.followBtn = resValue
                    }
                }
            }.resume()
        }
    }
}

//--@-------------------------------------------------------------------------------------------------------------------------------------------------


struct ProfilePageView: View {
    
    @Binding var isLoggedIn: Bool
    @Binding var userId:String
    @Binding var profile:Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = ProfilePageViewModel()
    
    
    var body: some View {
            NavigationView {
                ZStack {
                    ProfilePageImageView(viewModel:viewModel)
                        .environmentObject(appState)
                    VStack {
                        ProfilePageHeader(viewModel:viewModel)
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), radius: 7, x: 0, y: 5)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    if profile == true {
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
                }
                .onAppear {
                    viewModel.getMyImages(userId)
                    viewModel.getUserInfo(userId)
                }
                .sheet(isPresented: $viewModel.showImageViewer) {
                    if let selectedImage = appState.selectedImage, let selectedImageId = appState.selectedImageId {
                        ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
                    } else {
                        Text("Loading...")
                    }
                }
        }
        .ignoresSafeArea()
    }
}

//--@---------------------------------------------------------------------------------------------------------------------------------------------






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

//--@-------------------------------------------------------------------------------------------------------------------------------------------











struct ProfilePageHeader: View {
    
    @StateObject var viewModel:ProfilePageViewModel
    
    
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                GeometryReader { geo in
                    AsyncImage(url: URL(string: viewModel.profileUser != nil ? viewModel.profileUser.profile_image : "")) { phase in
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
                
                
                Text(viewModel.profileUser != nil ? "@"+viewModel.profileUser.user_at : "@")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                //--@유저_아이디
                
                
                Text(viewModel.profileUser != nil ? viewModel.profileUser.user_id: "")
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                //--@유저_닉네임
                
                
            }//--@VStack
            .frame(height: 180)
            
            //--@유저프로필_닉네임_아이디
            
//            Spacer()
            VStack(spacing: 20) {
                HStack(alignment: .bottom) {
                        VStack {
                            Image("pic!")
                                .resizable()
                                .frame(width: 13, height: 13)
                            
                            Text(String(viewModel.profileUser != nil ? viewModel.profileUser.pic: 0))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(width: 60)
                    
                    
                        Spacer()
                        VStack {
                            Text("Follow")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                            Text(String(viewModel.profileUser != nil ? viewModel.profileUser.follow: 0))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(width: 60)
                        Spacer()
                        VStack {
                            Text("Follower")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            
                            Text(String(viewModel.profileUser != nil ? viewModel.profileUser.follower: 0))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(width: 60)
                }//--@Hstack
                .frame(width: UIScreen.main.bounds.width * 0.55, height: 40)

                
                HStack(alignment: .top) {
                    HStack(alignment: .top) {
                        Text(viewModel.profileUser != nil ? viewModel.profileUser.description: "")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.55/2)
                    
                    if viewModel.myProfileOrNot == true { //내 프로필
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width * 0.5/2, height: 20, alignment: .center)
                    } else { //다른 프로필
                        
                        Button(action: {
                            
                            if viewModel.followBtn == false { //unfollow 되어있을때
                                viewModel.followBtn = true
                                viewModel.follow(viewModel.profileUser.id)
                            } else { //follow 일때
                                viewModel.followBtn = false
                                viewModel.unfollow(viewModel.profileUser.id)
                            }
                            
                        }, label: {
                            HStack {
                                Text(viewModel.followBtn ? "Unfollow" : "Follow")
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.5/2, height: 20, alignment: .center)
                            .contentShape(Rectangle())
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(Color(hexString: viewModel.followBtn ? "ABB2F2" : "4657F3"))
                       
                        
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.55, height: 40)
                
//                .background(.blue)
                
            }//---@VStack
            .frame(width: UIScreen.main.bounds.width * 0.6, height: 180)
            .padding(.leading, 10)
            Spacer()
        }//--@HStack
        .padding([.leading, .trailing])
        .frame(width: UIScreen.main.bounds.width, height: 170)
        .background( Color(.black))
        .clipShape(
            .rect(topLeadingRadius: 0, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 0)
        )
    }
}
//--@-------------------------------------------------------------------------------------------------------------------------------------------


struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        var viewModel = ProfilePageViewModel()
        
          ProfilePageHeader(viewModel:viewModel)
    }
}
