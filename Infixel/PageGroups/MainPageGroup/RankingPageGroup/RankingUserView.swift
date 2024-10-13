//
//  RankingUserView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI

struct RankingUserView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach($webSocketManager.rankingUsers, id: \.self) { ranking in
                    HStack(spacing:0) {
                        Text(String(ranking.rank.wrappedValue))
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .frame(width: 50)
                        
                        UserSingleView(profile_image: ranking.profile_image, user_id: ranking.user_id, pic_count: ranking.pic_count, follower_count: ranking.follower_count)
                    }
                }
            }
            .padding([.top, .bottom], 40)
        }
        .contentMargins([.top, .bottom], 30)
        .onAppear {
            webSocketManager.type = false
            webSocketManager.connect()
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
    }
}

#Preview {
    RankingUserView()
}
