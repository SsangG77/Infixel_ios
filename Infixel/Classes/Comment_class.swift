//
//  Comment_class.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/28.
//

import Foundation


class Comment : Identifiable, Decodable {
    /*
     1. uploader
     2. content
     3. date
     4. uuid
     */
    
    var id:String
    var created_at:String
    var content: String
    var user_id: String
    var image_id:String
    var user_name:String
    var profile_image:String
    
    init(id: String, created_at: String, content: String, user_id: String, image_id: String, user_name: String, profile_image: String) {
        self.id = id
        self.created_at = created_at
        self.content = content
        self.user_id = user_id
        self.image_id = image_id
        self.user_name = user_name
        self.profile_image = profile_image
    }
    
}
