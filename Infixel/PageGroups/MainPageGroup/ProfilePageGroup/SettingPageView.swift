//
//  SettingPageView.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI

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

#Preview {
    SettingPageView(isLoggedIn: .constant(true))
}
