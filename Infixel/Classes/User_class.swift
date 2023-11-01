//
//  Uploader_class.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/28.
//

import Foundation


class User {
    
    let id: UUID
    let user_nick : String
    let email : String
    let password: String
    var images:[SlideImage]
    //let profileImage
    
    init(user_nick:String) {
        self.id = UUID()
        self.email = "test"
        self.password = "test"
        self.images = []
        self.user_nick = user_nick
    }
    
    func setImage(image:SlideImage) {
        images.append(image)
    }
   
}
