//
//  UploadImagePlusView.swift
//  Infixel
//
//  Created by 차상진 on 7/9/24.
//

import SwiftUI

struct UploadImagePlusView: View {
    
    
    @EnvironmentObject var appState: AppState
    
    var size = 40.0
    
    var body: some View {
        // 플러스 모양 커스텀 이미지 버튼
        ZStack {
            Rectangle()
                .background(.ultraThinMaterial)
                .foregroundColor(.secondary.opacity(0.1))
                .clipShape(Circle())
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            
            Image("thick_plus")
                .resizable()
                .frame(width: size * 0.4, height: size  * 0.4)
                .clipShape(Circle())
        }
        .padding()
        .rotationEffect(appState.uploadPlusBtnClicked ? .degrees(45) : .degrees(0))
        .animation(.easeInOut, value: appState.uploadPlusBtnClicked)
    }
}


struct bellButtonView: View {
    var size = 40.0
    @EnvironmentObject var notificationService: NotificationService
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(.ultraThinMaterial)
                .foregroundColor(.secondary.opacity(0.1))
                .clipShape(Circle())
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            
            
            Image("bell")
                .resizable()
                .frame(width: size * 0.4, height: size  * 0.4)
            
            
            
            Circle()
                .frame(width: 8)
                .foregroundColor(notificationService.notification_flag ? .red : .clear)
                .offset(CGSize(width: 5.0, height: -8.0))
            
        }
        .padding()
        .padding(.trailing, -30)
        
    }
}

#Preview {
    bellButtonView()
}
