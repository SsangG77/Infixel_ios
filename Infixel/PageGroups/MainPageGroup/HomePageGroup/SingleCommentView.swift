//
//  SingleCommentView.swift
//  Infixel
//
//  Created by 차상진 on 4/17/24.
//

import SwiftUI

struct SingleCommentView: View {
    
//    @State var profile_image = "https://file3.instiz.net/data/cached_img/upload/2022/07/13/16/d9d56e0a46a0fd0a3bc907e738139525.jpg"
//    @State var user_name = "user1"
//    @State var created_at = "24/04/14"
//    @State var content = "comment lorem ipsum us not nade to me comment lorem ipsum us not nade to me comment lorem ipsum us not nade to me comment lorem ipsum us not nade to me comment lorem ipsum us not nade to me"
    
    @Binding var profile_image: String
    @Binding var user_name:String
    @Binding var created_at:String
    @Binding var content:String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImageView(imageURL: $profile_image)
                        //.resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(11)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(user_name)
                                .font(.system(size: 14, weight: .bold))
                            
                            Text(created_at)
                                .font(.system(size: 14, weight: .thin))
                        }
                        Text(content)
                            
                    }
                    Spacer()
                }
                .padding()
        
    }
}

//#Preview {
//    SingleCommentView()
//}
