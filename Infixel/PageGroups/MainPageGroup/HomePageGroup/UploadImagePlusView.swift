//
//  UploadImagePlusView.swift
//  Infixel
//
//  Created by 차상진 on 7/9/24.
//

import SwiftUI

struct UploadImagePlusView: View {
    
    
    @EnvironmentObject var appState: AppState
    
    var size = 50.0
    
    var body: some View {
        // 플러스 모양 커스텀 이미지 버튼
        ZStack {
            
            
            Rectangle()
                .background(.ultraThinMaterial)
                .foregroundColor(.secondary.opacity(0.1))
                .clipShape(Circle())
                .frame(width: size, height: size)
            
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

//#Preview {
//    UploadImagePlusView()
//}
