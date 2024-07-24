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
    
    
}


struct ProfilePageView: View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
            
            NavigationView {
                ZStack {
                
                    VStack {
                        ProfilePageHeader()
                        Spacer()
                    }
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            NavigationLink(destination: SettingPageView(isLoggedIn: $isLoggedIn)) {
                                    Text("setting")
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
            VStack {
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
                .frame(width: 80, height: 80)
                
                Text(viewModel.user_at)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.light)
                
                Text(viewModel.user_id)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                
            }//--@VStack
            .frame(height: 180)
            
            Spacer()
            
        }//--@HStack
        .padding()
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
