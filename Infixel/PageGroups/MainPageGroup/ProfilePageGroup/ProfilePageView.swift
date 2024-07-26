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
    @Published var description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    
    
}


struct ProfilePageView: View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
            
            NavigationView {
                ZStack {
                
                    VStack {
                        ProfilePageHeader()
                            .shadow(color: Color.black.opacity(0.5), radius: 7, x: 0, y: 5)
                        Spacer()
                    }
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: SettingPageView(isLoggedIn: $isLoggedIn)) {
                                    Text(". . .")
                                    .padding()
                                
                            }//NavigationLink
                        }
                        Spacer()
                            
                    }
                }
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
                                Text("Failed to load image, retrying...")
                                    .foregroundColor(.white)
                            }
                           
                        @unknown default:
                            EmptyView()
                        }//--@switch
                    }//--@AsyncImage
                    
                }//--@GeometryReader
                .frame(width: 70, height: 70)
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
            .frame(width: UIScreen.main.bounds.width * 0.3, height: 180)
            
            //--@유저프로필_닉네임_아이디
            
//            Spacer()
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    VStack {
                        Image("pic!")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(String(viewModel.pic))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        Text("Follow")
                            .foregroundColor(.white)
                        
                        Text(String(viewModel.follow))
                            .foregroundColor(.white)
                    }
                    
                    VStack {
                        Text("Follower")
                            .foregroundColor(.white)
                        
                        Text(String(viewModel.follower))
                            .foregroundColor(.white)
                    }
                }
                
                VStack {
                    Text(viewModel.description)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
//                .frame(width: UIScreen.main.bounds.width * 0.7)
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
