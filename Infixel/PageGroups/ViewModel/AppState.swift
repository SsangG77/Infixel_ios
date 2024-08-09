//
//  AppState.swift
//  Infixel
//
//  Created by 차상진 on 6/18/24.
//

import Foundation
import Combine

class AppState : ObservableObject {
    @Published var selectedTab: Tab = Tab.house 
//    {
//        didSet {
//            ensureMainThread(error_value: "selectedTab")
//        }
//    }
    
    
    enum Tab {
        case house
        case search
        case chart
        case save
        case profile
    }
    
    @Published var isLoggedIn                       : Bool       = false
 
    @Published var infoBoxReset                     : Bool       = false
    @Published var albumsOpen                       : Bool       = false
    @Published var commentsOpen                     : Bool       = false
    @Published var threeDotsOpen                    : Bool       = false
    
    @Published var addAlbumOffset                   : CGFloat    = 1000
    @Published var commentsOffset                   : CGFloat    = 1000
    @Published var threeDotsOffset                  : CGFloat    = 1000
    
    //slideImage
    @Published var slideImage : SlideImage = SlideImage()
    
    
    
    //imageViewer
    @Published var imageViewerOrNot                 : Bool       = false    //commentView, addAlbumView가 나타날때 현재 뷰가 imageViewer인지 아닌지 판단하는 함수
    @Published var albumsOpen_imageViewer           : Bool       = false
    @Published var commentOpen_imageViewer          : Bool       = false
    @Published var threedotsOpen_imageViewer        : Bool       = false
    
    @Published var addAlbumOffset_imageViewer       : CGFloat    = 1000
    @Published var commentOffset_imageViewer        : CGFloat    = 1000
    @Published var threedotsOffset_imageViewer      : CGFloat    = 1000
    
    //이미지에 있는 댓글 수
    @Published var commentsCount                    : Int        = 0
    
    //
    @Published var selectedImage                    : String?    = nil
    @Published var selectedImageId                  : String?    = nil

    func selectImage(imageUrl: String, imageId: String) {
        selectedImage = imageUrl
        selectedImageId = imageId
    }
    func selectImageReset() {
        selectedImage = nil
        selectedImageId = nil
    }
    
    //searchPage 버튼 클릭 유무 변수
    @Published var searchBtnClicked                 : Bool       = false
    
    //Search album
    @Published var selectedAlbum: Album? = nil
    
    //SearchAlbumPageView_album 변수
    @Published var album_selectedImage : String? = nil
    @Published var album_selectedImageId : String? = nil
    
    
    //이미지 업로드 플러스 버튼 클릭 유무 변수
    @Published var uploadPlusBtnClicked = false
    
    //점 세개 버튼 눌렀을때 뷰 offset
    
    
    
    @Published var profileUserId = ""
  
    
//    private func ensureMainThread(error_value:String) {
//        if !Thread.isMainThread {
//            VarCollectionFile.myPrint(title: "enviroment error", content: error_value)
//            fatalError("Publishing changes from background threads is not allowed.")
//        }
//    }
}
