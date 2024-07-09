//
//  InfixelApp.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

@available(iOS 17.0, *)
@main
struct InfixelApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
        }
    }
}
