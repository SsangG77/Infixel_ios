//
//  Album_class.swift
//  Infixel
//
//  Created by 차상진 on 1/11/24.
//

import Foundation

class Album: Identifiable {
    var tumbnailLink : String
    var albumName : String
    let id : UUID
    
    init(thumbnailLink:String, albumName:String) {
        self.id = UUID()
        self.tumbnailLink = thumbnailLink
        self.albumName = albumName
    }
}
