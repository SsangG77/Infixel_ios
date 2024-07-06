//
//  SearchPageView_user.swift
//  Infixel
//
//  Created by 차상진 on 6/28/24.
//

import SwiftUI

struct SearchPageView_user: View {
    
    //@State var userCount = 0
    @Binding var users:[SearchSingleUser]
    
    @EnvironmentObject var appState: AppState
    
    
    var body: some View {
        ScrollView {
            
            if !users.isEmpty {
                ForEach($users, id:\.self) { user in
                    SearchUserSingleView(
                        profile_image: user.profile_image,
                        user_id: user.user_id,
                        pic_count: user.pic_count,
                        follower_count: user.follower_count
                    )
                }
                
            } else {
                Text("검색 결과가 없습니다.")
            }
        }
    }
    
    
}

//#Preview {
//    SearchPageView_user()
//}
