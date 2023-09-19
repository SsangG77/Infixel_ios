//
//  AsyncImageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

struct AsyncImageView: View {
    
    var imageURL: URL?

    var body: some View {
        GeometryReader { geometry in
            // 이미지의 넓이를 기기의 절반으로 설정
            let imageWidth = geometry.size.width
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 이미지를 로드 중일 때 표시할 로딩 화면
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        
                       
                case .failure:
                    Text("Failed to load image") // 이미지 로드 실패 시 메시지
                @unknown default:
                    Text("Unknown state") // 알 수 없는 상태 처리
                }
            }.frame(width: imageWidth)
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageURL: URL(string:  "https://upload3.inven.co.kr/upload/2023/03/23/bbs/i14867368378.jpg"))
    }
}
