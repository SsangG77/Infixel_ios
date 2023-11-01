//
//  SlideImage_class.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/28.
//

import Foundation


class SlideImage: Identifiable, Hashable {
   
    let id: UUID                // 고유 아이디
    let link: String            // 이미지 링크
//    let date:String             // 업로드 날짜
    let uploader: User          // 업로더
    var pic: Int                //좋아요 갯수
    var description: String    //이미지 설명 글
    var tags:[String] = ["tagasdf1", "tag2", "tag3", "tag4"]
//    var comments:[Comment]      //댓글 목록
    
//    init(uploader: User, link: String, pic: Int, description: String) {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 표시할 날짜 및 시간 형식 지정
//        
//        self.id = UUID()
//        self.date = dateFormatter.string(from: Date())
//        self.uploader = uploader
//        self.link = link
//        self.pic = 0
//        self.description = description
//        self.comments = []
//    }
    
    init(link: String, pic:Int, description:String, user:User) {
        self.id = UUID()
        self.link = link
        self.pic = pic
        self.description = description
        self.uploader = user
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
    
//    //댓글 달기
//    func setComment(comment:Comment) {
//        comments.append(comment)
//    }
//    
//    //좋아요 올리기
//    func upPic() {
//        self.pic += 1
//    }
}

