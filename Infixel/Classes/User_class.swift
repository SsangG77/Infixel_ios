//
//  Uploader_class.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/28.
//

import Foundation


class User {
    
    let id: String
    let user_nick : String
    var thumbnail_link : String
    let user_name : String
    //let profileImage
    
    init(id:String, user_nick:String, user_name:String, thumbnail_link:String) {
        self.id = id
        self.user_nick = user_nick
        self.thumbnail_link = thumbnail_link
        self.user_name = user_name
    }
    
   
}
