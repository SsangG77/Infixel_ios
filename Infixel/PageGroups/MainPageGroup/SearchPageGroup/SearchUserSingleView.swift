//
//  SearchUserSingleView.swift
//  Infixel
//
//  Created by 차상진 on 6/30/24.
//

import SwiftUI

struct SearchUserSingleView: View {
    
    
//    @State var profile_image = "http://localhost:3000/image/resjpg?filename=haewon4.jpeg"
//    @State var user_id = "test_user"
//    @State var pic_count = 4320
//    @State var follower_count = 120
    @Binding var profile_image:String
    @Binding var user_id:String
    @Binding var pic_count:String
    @Binding var follower_count:String
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImageView(imageURL: $profile_image)
                        //.resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .cornerRadius(11)
                    
                    VStack(alignment: .leading) {
                        Text(user_id)
                            .padding(.bottom, 3)
                        
                        
                        HStack(alignment: .center, spacing: 10) {
                            
                            HStack(spacing: 5) {
                                Image("pic!")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.bottom, 1)
                                
                                Text(pic_count)
                                    .font(.system(size: 14, weight: .thin))
                            }
                            
                            Text("|")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            
                            Text(follower_count + " 팔로워")
                                .font(.system(size: 14, weight: .thin))
                        }
                    }
                    Spacer()
                }
                .padding()
    }
}

//#Preview {
//    SearchUserSingleView()
//}
