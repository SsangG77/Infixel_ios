//
//  VarCollectionFile.swift
//  Infixel
//
//  Created by 차상진 on 1/25/24.
//

import Foundation


struct VarCollectionFile {
    
    
    static let server = "192.168.31.200:3000"
    
    static let host = "http://" + server
    
    
    static let randomImageURL           = host + "/image/randomimage" //이 요청문은 슬라이드 이미지 객체를 가져옴
    static let resjpgURL                = host + "/image/resjpg?filename=" //jpg 파일을 가져옴
    static let imageIdURL               = host + "/image/getimagefromid"
    static let randomJpgURL             = host + "/image/randomjpg"
    static let imageUploadURL           = host + "/image/upload"
    static let reportImageURL           = host + "/image/report"
    static let myImageURL               = host + "/image/myimage"
    
    static let loginURL                 = host + "/user/login"
    static let signupURL                = host + "/user/signup"
    static let userSearchURL            = host + "/user/search"
    static let userProfileURL           = host + "/user/profile"
    static let followURL                = host + "/user/follow"
    static let unfollowURL              = host + "/user/unfollow"
    static let followOrNotURL           = host + "/user/followornot"
    
    static let picOrNotURL              = host + "/pic/ornot"
    static let picUpURL                 = host + "/pic/up"
    static let picDownURL               = host + "/pic/down"
    
    static let commentGetURL            = host + "/comment/get"
    static let commentSetURL            = host + "/comment/set"
    static let commentCountURL          = host + "/comment/count"
    
    static let imageGetAlbumURL         = host + "/imagealbums/get"
    static let imageSetAlbumURL         = host + "/imagealbums/set"
    static let albumSearchURL           = host + "/imagealbums/search"
    static let searchAlbumImageURL      = host + "/imagealbums/images"
    static let addAlbumURL              = host + "/imagealbums/add"
    static let getAlbumURL              = host + "/imagealbums/getinfo"
    static let updateAlbumURL           = host + "/imagealbums/update"
    
    static let tagsGetURL               = host + "/tags/get"
    static let tagsSearchURL            = host + "/tags/search"
    
    
    //WebSocket
    static let ws = "ws://" + server
    
    static let rankingImageURL   = ws + "/imagerank"
    static let rankingUserURL    = ws + "/userrank"
    
    
    
    
    static func myPrint<T>(title:String, content:T) {
        print("")
        print("======================= \(title) =======================")
        print(content)
        print("")
        
    }
    
    
}
