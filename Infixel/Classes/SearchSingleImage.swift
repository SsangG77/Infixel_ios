//
//  SearchSingleImage.swift
//  Infixel
//
//  Created by 차상진 on 6/30/24.
//

import Foundation

struct SearchSingleImage: Identifiable, Decodable, Hashable {
    var id: String
    var image_name: String
    
    init(id: String, image_name: String) {
        self.id = id
        self.image_name = image_name
    }
    
    // Hashable 프로토콜을 준수하기 위해 hash(into:) 메서드를 추가합니다.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable 프로토콜을 준수하기 위해 == 연산자를 구현합니다.
    static func == (lhs: SearchSingleImage, rhs: SearchSingleImage) -> Bool {
        return lhs.id == rhs.id && lhs.image_name == rhs.image_name
    }
}
