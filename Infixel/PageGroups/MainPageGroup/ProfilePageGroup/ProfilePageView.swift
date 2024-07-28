//
//  ProfilePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI


class ProfilePageViewModel: ObservableObject {
    @Published var profileImage = VarCollectionFile.randomJpgURL
    @Published var user_at = "@user_01"
    @Published var user_id = "User 01"
    @Published var pic = 12345
    @Published var follow = 343
    @Published var follower = 7510
    @Published var description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. da;sds;ldkmcsla"
    
    
    
    
}


struct ProfilePageView: View {
    
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var appState: AppState
    @State var showImageViewer = false
    
    @State var images = [
        SearchSingleImage(id: "1", image_name: VarCollectionFile.resjpgURL + "winter2.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "haewon3.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon.webp"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "winter4.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "winter5.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon1.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon2.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "1720980126019-957469642.jpg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "1721216091689-620096316.jpg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon1.jpeg"),
    ]
    
    var body: some View {
            
            NavigationView {
                ZStack {
                    ScrollView {
                        
                        
                        ImageGridView(images: $images) { imageId, imageName in
                            appState.selectedImage = imageName
                            appState.selectedImageId = imageId
                            showImageViewer = true
                        }
                        
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.1)
                    .contentMargins(.top, UIScreen.main.bounds.height * 0.13)
                    .contentMargins(.bottom, 40)
                
                    VStack {
                        ProfilePageHeader()
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
                .sheet(isPresented: $showImageViewer) {
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
    var body: some View {
        ScrollView {
            
        }
    }
}












struct ProfilePageHeader: View {
    
    var viewModel = ProfilePageViewModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                GeometryReader { geo in
                    AsyncImage(url: URL(string:viewModel.profileImage)) { phase in
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
                
                
                Text(viewModel.user_at)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                //--@유저_아이디
                
                
                Text(viewModel.user_id)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                //--@유저_닉네임
                
                
            }//--@VStack
            .frame(height: 180)
            
            //--@유저프로필_닉네임_아이디
            
//            Spacer()
            VStack(spacing: 20) {
                
                HStack(alignment: .bottom, spacing: 30) {
                    VStack {
                        Image("pic!")
                            .resizable()
                            .frame(width: 13, height: 13)
                        
                        Text(String(viewModel.pic))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        Text("Follow")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        
                        Text(String(viewModel.follow))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        Text("Follower")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        
                        Text(String(viewModel.follower))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .frame(height: 40)
                
                VStack {
                    Text(viewModel.description)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 40)
            }//VStack
            .frame(width: UIScreen.main.bounds.width * 0.7)
            
            
            
        
        }//--@HStack
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
        .background(Color(.black))
        .clipShape(
            .rect(topLeadingRadius: 0, bottomLeadingRadius: 30, bottomTrailingRadius: 30, topTrailingRadius: 0)
        )
        
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
        ProfilePageView(isLoggedIn: .constant(true))
    }
}
