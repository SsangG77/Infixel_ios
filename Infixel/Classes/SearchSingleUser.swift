//
//  SearchSingleUser.swift
//  Infixel
//
//  Created by 차상진 on 6/30/24.
//

import Foundation

class SearchSingleUser: Identifiable, Decodable, Hashable {
    var id: String
    var user_id: String
    var user_name:String
    var profile_image:String
    var follower_count:String
    var pic_count:String
    
    init(id: String, user_id: String, user_name: String, profile_image: String, follower_count: String, pic_count: String) {
        self.id = id
        self.user_id = user_id
        self.user_name = user_name
        self.profile_image = profile_image
        self.follower_count = follower_count
        self.pic_count = pic_count
    }
    
    
    static func == (lhs: SearchSingleUser, rhs: SearchSingleUser) -> Bool {
        return lhs.id == rhs.id &&
        lhs.user_id == rhs.user_id &&
        lhs.user_name == rhs.user_name &&
        lhs.profile_image == rhs.profile_image &&
        lhs.follower_count == rhs.follower_count &&
        lhs.pic_count == rhs.pic_count
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
  
}
