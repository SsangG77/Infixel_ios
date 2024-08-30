//
//  SettingPageView.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI

struct SettingPageView: View {
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var notificationService: NotificationService
    
    var body: some View {
        
        List {
            Section("계정 관리") {
                NavigationLink(destination: ProfileEditView()) {
                    Text("프로필 편집")
                }
                NavigationLink(destination: ImageEditView()) {
                    Text("이미지 관리")
                }
            }
            
            Section("로그인") {
                Button("로그아웃") {
                    UserDefaults.standard.removeObject(forKey: "notifications")
                    notificationService.notifications = []
                    isLoggedIn = false
                }
                .foregroundColor(.red)
            }
        }
    }
}



struct ProfileEditView:View {
    var body: some View {
        VStack {
            
        }
    }
}

struct ImageEditView: View {
    var body: some View {
        VStack {
            
        }
    }
}



class SettingViewModel: ObservableObject {
    
}

//#Preview {
//    SettingPageView(isLoggedIn: .constant(true))
//}
