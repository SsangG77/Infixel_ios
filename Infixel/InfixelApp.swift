//
//  InfixelApp.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

@main
struct InfixelApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
        }
    }
}
