//
//  MainView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

@available(iOS 17.0, *)
struct MainView: View {
    
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var appState: AppState
    @State var slideImage: SlideImage = SlideImage()
//    @State var slideImages: [SlideImage] = []
    
    @State var userId = UserDefaults.standard.string(forKey: "user_id")!
    @State var profile = true
    
    //-------
    @State private var showImageViewer: Bool = false
    
    @Namespace private var animationNamespace
 
    
    
    var body: some View {
        
        ZStack {
            switch appState.selectedTab {
            case .house:
                HomePageView(slideImage: $slideImage, slideImages: $appState.slideImages)
                    .environmentObject(appState)
                
            case .search:
                SearchPageView(animationNamespace: animationNamespace, slideImages: $appState.slideImages)
                    .environmentObject(appState)
                
            case .chart:
                RankingView(slideImages: $appState.slideImages)
                    .ignoresSafeArea()
                
                
            case .save:
                SavePageView(slideImages: $appState.slideImages)
                
            case .profile:
                ProfilePageView(isLoggedIn: $isLoggedIn, userId: $userId, profile: $profile, slideImages: $appState.slideImages)
            
            }//switch

            NavView()
                .padding(.bottom, 10)
                .environmentObject(appState)
                .offset(y: appState.uploadPlusBtnClicked ? 200 : 0)
                .animation(.easeInOut, value: appState.uploadPlusBtnClicked)
            
            AddAlbumView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.addAlbumOffset)
                .animation(.easeInOut)
            
            CommentsView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.commentsOffset)
                .animation(.easeInOut)
            
            
            ThreeDotsView(slideImage: $slideImage, slideImages: $appState.slideImages)
                .environmentObject(appState)
                .offset(y: appState.threeDotsOffset)
                .animation(.easeInOut)
            
            
        }//zstack
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay(
            Group {
                if let selectedAlbum = appState.selectedAlbum {
                    AlbumDetailView(album: $appState.selectedAlbum, slideImages: $appState.slideImages, animationNamespace: animationNamespace) {
                        withAnimation(.spring()) {
                            appState.selectedAlbum = nil
                        }
                    }
                    
                }
            }
        )
        
        
    }
    
}
