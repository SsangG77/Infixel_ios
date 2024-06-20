//
//  Album_class.swift
//  Infixel
//
//  Created by 차상진 on 1/11/24.
//

import Foundation

class Album: Identifiable, Decodable {
    var id : String
    var album_name : String
    var created_at: String
    var profile_link : String
    var count : Int
    
    init(id: String, created_at:String, profile_link:String, album_name:String, count:Int) {
        self.id = id
        self.created_at = created_at
        self.profile_link = profile_link
        self.album_name = album_name
        self.count = count
    }
}
