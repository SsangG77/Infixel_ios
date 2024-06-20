//
//  MainView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct MainView: View {
    
    @Binding var isLoggedIn: Bool
    
    
    @ObservedObject var tabViewModel: TabViewModel = TabViewModel()
    
    @State var selectedTab: TabViewModel.Tab = .house
    
    @State var albumsOpen = false
    @State private var addAlbumOffset: CGFloat = 1000
    
    @State var commentsOpen = false
    @State var commentsOffset: CGFloat = 1000
    
    @State var slideImage: SlideImage = SlideImage()
    
    
//    @State var albumList:[Album] = [
//        Album(thumbnailLink: "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/05/11/029fdc46-8afe-4ba2-ac5b-3f6375d5f57a.jpg", albumName: "김채원"),
//        Album(thumbnailLink: "https://mblogthumb-phinf.pstatic.net/MjAyMjAxMDFfMTgg/MDAxNjQxMDIyMDkxNzk1.-qCV6vAD3jZ-Oy8y-m1yb7kA11onbF6j4Ve5PlRHxvkg.MwNKmochjVpTvb_FxZdHDCkOTxuCxKvQd15wDo2m6M0g.JPEG.xaintwine/1.jpeg?type=w800", albumName: "카리나"),
//        Album(thumbnailLink: "https://cdn.newskrw.com/news/photo/202306/17390_24130_811.jpg", albumName: "윈터")
//    ]
    
    
    
    var body: some View {
        
        ZStack {
            switch selectedTab {
            case .house:
                HomePageView(albumsOpen: $albumsOpen, addAlbumOffset : $addAlbumOffset, commentsOpen: $commentsOpen, commentsOffset: $commentsOffset, slideImage: $slideImage)
            case .search:
                SearchPageView()
            case .plus:
                Text("사진 앨범 나오게 하기")
            case .save:
                SavePageView()
            case .profile:
                ProfilePageView(isLoggedIn: $isLoggedIn)
            
            }

            
            VStack {
                NavView(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
            
            AddAlbumView(slideImage: $slideImage, albumsOpen: $albumsOpen, addAlbumOffset : $addAlbumOffset)
                .offset(y : addAlbumOffset)
                .animation(.easeInOut)
            
            CommentsView(slideImage: $slideImage, commentsOpen: $commentsOpen, commentsOffset: $commentsOffset)
                .offset(y : commentsOffset)
                .animation(.easeInOut)
        }
        .onAppear {
            print("MainPage OnAppear")
            
            
           
        }
        
    }
    
}
