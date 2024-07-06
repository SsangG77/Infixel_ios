//
//  ContentView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    
    @Binding var isLoggedIn: Bool
    
    @StateObject private var appState = AppState()
    

    
    var body: some View {
        
        if isLoggedIn {
            MainView(isLoggedIn: $isLoggedIn)
                .environmentObject(appState)
        } else {
            
            LoginPage(isLoggedIn: $isLoggedIn)
            
            //프리뷰용
            //LoginPage(isLoggedIn: isLoggedIn)
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
