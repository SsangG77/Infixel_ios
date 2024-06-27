//
//  AppState.swift
//  Infixel
//
//  Created by 차상진 on 6/18/24.
//

import Foundation
import Combine

class AppState : ObservableObject {
    @Published var selectedTab: Tab = Tab.house {
        didSet {
            ensureMainThread(error_value: "selectedTab")
        }
    }
    
    
    enum Tab {
        case house
        case search
        case plus
        case save
        case profile
    }
    
    @Published var isLoggedIn           : Bool       = false {
        didSet {
            ensureMainThread(error_value: "isLoggedIn")
        }
    }
    @Published var infoBoxReset         : Bool       = false {
        didSet {
            ensureMainThread(error_value: "infoBoxReset")
        }
    }
    @Published var albumsOpen           : Bool       = false {
        didSet {
            ensureMainThread(error_value: "albumOpen")
        }
    }
    @Published var commentsOpen         : Bool       = false {
        didSet {
            ensureMainThread(error_value: "commentOpen")
        }
    }
    @Published var addAlbumOffset       : CGFloat    = 1000 {
        didSet {
            ensureMainThread(error_value: "addAlbumOffset")
        }
    }
    @Published var commentsOffset       : CGFloat    = 1000 {
        didSet {
            ensureMainThread(error_value: "commentsOffset")
        }
    }
    
    @Published var showImageViewer      : Bool      = false
    
//    @Published var slideImage           : SlideImage = SlideImage() {
//        didSet {
//            ensureMainThread(error_value: "slideImage")
//        }
//    }
    
    @Published var selectedImage: String? = nil
    @Published var selectedImageId: String? = nil
    
    func selectImage(imageUrl: String, imageId: String) {
        selectedImage = imageUrl
        selectedImageId = imageId
    }
    
    
    private func ensureMainThread(error_value:String) {
        if !Thread.isMainThread {
            VarCollectionFile.myPrint(title: "enviroment error", content: error_value)
            fatalError("Publishing changes from background threads is not allowed.")
        }
    }
    
}
