//
//  MainView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct MainView: View {
    
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var appState: AppState
    @State var slideImage: SlideImage = SlideImage()
    
    
    //-------
    @State private var showImageViewer: Bool = false
 
    
    
    var body: some View {
        
        ZStack {
            switch appState.selectedTab {
            case .house:
                HomePageView(slideImage: $slideImage)
                    .environmentObject(appState)
//                ScrollView_test(slideImage: $slideImage)
//                    .environmentObject(appState)
                
            case .search:
                SearchPageView()
                
            case .plus:
                Text("사진 앨범 나오게 하기")
                
            case .save:
                SavePageView()
                
            case .profile:
                ProfilePageView(isLoggedIn: $isLoggedIn)
            
            }//switch

            NavView()
                .padding(.bottom, 10)
                .environmentObject(appState)
            
            AddAlbumView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.addAlbumOffset)
                .animation(.easeInOut)
            
            CommentsView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.commentsOffset)
                .animation(.easeInOut)
            
        }//zstack
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
    
}
