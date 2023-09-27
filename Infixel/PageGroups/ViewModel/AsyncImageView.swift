//
//  AsyncImageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.



import SwiftUI

struct AsyncImageView: View {
    
    var imageURL: URL?

    var body: some View {
        GeometryReader { geometry in
            // 이미지의 넓이를 기기의 절반으로 설정
            let imageWidth = geometry.size.width
            let imageHeight = geometry.size.height
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 이미지를 로드 중일 때 표시할 로딩 화면
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        //.ignoresSafeArea()
                        
                       
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
        
        @State var images:[String] = [
            "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/06/15/ebcf24c6-8c5e-4b9c-bc44-44010e91745a.jpg",
            "https://i2.tcafe2a.com/230702/thumb-00c7090b30a08df66089fe0d7d036b92_1688268591_5081_835x1041.jpg",
            "https://image5jvqbd.fmkorea.com/files/attach/new3/20230609/3655109/3035547727/5851858710/c228b8ea29d0fcefee7fabe868a037a1.jpeg",
            "https://pbs.twimg.com/media/FpeiX-yaAAEEG6J?format=jpg&name=4096x4096",
            "https://res.heraldm.com/phpwas/restmb_jhidxmake.php?idx=5&simg=202111042118469934178_20211104211913_01.jpg",
            "https://file3.instiz.net/data/file3/2023/05/26/3/9/1/39170b65f9dd832bae8fe204cc7278d5.jpg",
            "https://cdn.newsculture.press/news/photo/202207/509775_619054_128.jpg",
            "https://upload3.inven.co.kr/upload/2023/03/23/bbs/i14867368378.jpg",
        ]
        AsyncImageView(imageURL: URL(string:  images[7]))
    }
}

