//
//  Album_class.swift
//  Infixel
//
//  Created by 차상진 on 1/11/24.
//

import Foundation

class Album: Identifiable, Decodable, Hashable {
    
    
    var id : String
    var album_name : String
    var created_at: String
    var profile_link : String
    var count : Int
    
    init() {
        self.id = UUID().uuidString
        self.created_at = "2024/07/02"
        self.album_name = "init"
        self.profile_link = VarCollectionFile.randomJpgURL
        self.count = -1
    }
    
    
    init(id: String, created_at:String, profile_link:String, album_name:String, count:Int) {
        self.id = id
        self.created_at = created_at
        self.profile_link = profile_link
        self.album_name = album_name
        self.count = count
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id &&
        lhs.album_name == rhs.album_name &&
        lhs.created_at == rhs.created_at &&
        lhs.profile_link == rhs.profile_link &&
        lhs.count == rhs.count
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
