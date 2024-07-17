//
//  SlideImage_class.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/28.
//

import Foundation


class SlideImage: Identifiable, Hashable, ObservableObject, Decodable {
   
    var id: String            // 고유 아이디
    var link: String            // 이미지 링크
    var user_nick:String
    var profile_image:String
    var pic: Int                //좋아요 갯수
    var description: String    //이미지 설명 글

    
    init() {
        self.id = UUID().uuidString
        self.link = "http://localhost:3000/image/resjpg?filename=haewon4.jpeg"
        self.pic = 0
        self.description = "init 슬라이드 이미지 객체"
        self.user_nick = "init"
        self.profile_image = "http://localhost:3000/image/resjpg?filename=winter6.jpeg"
    }
    

    
    init(id:String, link: String, pic:Int, description:String, user_nick:String, profile_image:String) {
        self.id = id
        self.link = link
        self.pic = pic
        self.description = description
        self.user_nick = user_nick
        self.profile_image = profile_image
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        // 다른 프로퍼티들도 combine
    }

    // Equatable 프로토콜을 준수하기 위한 메서드
    static func == (lhs: SlideImage, rhs: SlideImage) -> Bool {
        return lhs.id == rhs.id
        // 다른 프로퍼티들도 비교
    }
    
}

