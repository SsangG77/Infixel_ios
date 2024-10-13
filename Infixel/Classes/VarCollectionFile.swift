//
//  VarCollectionFile.swift
//  Infixel
//
//  Created by 차상진 on 1/25/24.
//

import Foundation


struct VarCollectionFile {
    
    static let server = "infixel-server.com" //AWS EC2 IP
//    static let server = "192.168.31.200:3000" // <- 로컬 ip
     
    static let host = "https://" + server //AWS EC2
//    static let host = "http://" + server // 로컬
    
    
    static let randomImageURL           = host + "/image/randomimage"
    static let resjpgURL                = host + "/image/resjpg?filename="
    static let imageIdURL               = host + "/image/getimagefromid"
    static let randomJpgURL             = host + "/image/randomjpg"
    static let imageUploadURL           = host + "/image/upload"
    static let reportImageURL           = host + "/image/report"
    static let myImageURL               = host + "/image/myimage"
    static let deleteImageURL           = host + "/image/delete"
    
    static let loginURL                 = host + "/user/login"
    static let kakaoLoginURL            = host + "/user/kakaologin"
    static let appleLoginURL            = host + "/user/applelogin"
    static let signupURL                = host + "/user/signup"
    static let userSearchURL            = host + "/user/search"
    static let userProfileURL           = host + "/user/profile"
    static let followURL                = host + "/user/follow"
    static let unfollowURL              = host + "/user/unfollow"
    static let followOrNotURL           = host + "/user/followornot"
    static let getProfileImageURL       = host + "/user/profile-image"
    static let updateProfileURL         = host + "/user/update"
    static let userDisableURL           = host + "/user/disable"
    
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
    static let deleteImageFromAlbumURL  = host + "/imagealbums/delete-image"
    
    
    static let tagsGetURL               = host + "/tags/get"
    static let tagsSearchURL            = host + "/tags/search"
    
    
    //WebSocket
    static let ws = "wss://" + server // AWS EC2
//    static let ws = "ws://" + server // 로컬
    
    static let rankingImageURL   = ws + "/imagerank"
    static let rankingUserURL    = ws + "/userrank"
    
    
    
    
    static func myPrint<T>(title:String, content:T) {
        print("")
        print("======================= \(title) =======================")
        print(content)
        print("")
        
    }
    
    
}
