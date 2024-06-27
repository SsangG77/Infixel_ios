//
//  VarCollectionFile.swift
//  Infixel
//
//  Created by 차상진 on 1/25/24.
//

import Foundation


struct VarCollectionFile {
    static let host = "http://localhost:3000"
    static let randomImageURL = host + "/image/randomimage" //이 요청문은 슬라이드 이미지 객체를 가져옴
    static let resjpgURL = host + "/image/resjpg?filename=" //jpg 파일을 가져옴
    static let imageIdURL = host + "/image/getimagefromid"
    
    static let loginURL = host + "/user/login"
    static let signupURL = host + "/user/signup"
    
    static let picOrNotURL = host + "/pic/ornot"
    static let picUpURL = host + "/pic/up"
    static let picDownURL = host + "/pic/down"
    
    static let commentGetURL = host + "/comment/get"
    static let commentSetURL = host + "/comment/set"
    
    static let imageGetAlbumURL = host + "/imagealbums/get"
    static let imageSetAlbumURL = host + "/imagealbums/set"
    
    static let tagsGetURL = host + "/tags/get"
    static let tagsSearchURL = host + "/tags/search"
    
    
    static func myPrint<T>(title:String, content:T) {
        print("")
        print("======================= \(title) =======================")
        print(content)
        print("")
        
    }
    
    
}
