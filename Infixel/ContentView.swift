//
//  ContentView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI
import UIKit

@available(iOS 17.0, *)
struct ContentView: View {
    
    @Binding var isLoggedIn: Bool
//    var isLoggedIn: Bool
    
    @StateObject private var appState = AppState()
    
    @ObservedObject var loginViewModel = LoginButtonViewModel()
    @ObservedObject var signupViewModel = SignUpViewModel()

    var appDelegate = AppDelegate()
    
    var body: some View {
        
        if isLoggedIn {
            MainView(isLoggedIn: $isLoggedIn)
                .environmentObject(appState)
        } else {
            
            LoginPage(isLoggedIn: $isLoggedIn, loginViewModel: loginViewModel, signupViewModel: signupViewModel)
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        //프리뷰용 변수
//        @AppStorage("isLoggedIn") var isLoggedIn = false
//        
//        ContentView(isLoggedIn: $isLoggedIn)
//    }
//}

