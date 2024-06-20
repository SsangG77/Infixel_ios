//
//  TwoRowImageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/15.
//

import SwiftUI

struct TwoRowImageView: View {
    var body: some View {
        
        @State var images:[String] = [
            "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/06/15/ebcf24c6-8c5e-4b9c-bc44-44010e91745a.jpg",
            "https://i2.tcafe2a.com/230702/thumb-00c7090b30a08df66089fe0d7d036b92_1688268591_5081_835x1041.jpg",
            "https://pbs.twimg.com/media/FpeiX-yaAAEEG6J?format=jpg&name=4096x4096",
            "https://image5jvqbd.fmkorea.com/files/attach/new3/20230609/3655109/3035547727/5851858710/c228b8ea29d0fcefee7fabe868a037a1.jpeg",
            "https://res.heraldm.com/phpwas/restmb_jhidxmake.php?idx=5&simg=202111042118469934178_20211104211913_01.jpg",
            "https://file3.instiz.net/data/file3/2023/05/26/3/9/1/39170b65f9dd832bae8fe204cc7278d5.jpg",
            "https://cdn.newsculture.press/news/photo/202207/509775_619054_128.jpg",
            "https://upload3.inven.co.kr/upload/2023/03/23/bbs/i14867368378.jpg",
            
        ]
        
        
        HStack {
            GeometryReader { geometry in
                VStack{
                    ForEach(0..<images.count) { i in
                        if i % 2 == 0 {
                            GeometryReader { geometry in
                                let imageWidth = geometry.size.width
                                AsyncImageView(imageURL: $images[i])
                                    .cornerRadius(20)
                                    .frame(width: imageWidth)
                            }//GeometryReader
                        }//if
                    }//ForEach
                }//VStack
                .padding(.leading, 20)
                .padding(.trailing, 10)
                .frame(height: geometry.size.height * 1.3)
                //.offset(y: -100)
                .position(x: UIScreen.main.bounds.size.width / 4, y: UIScreen.main.bounds.size.height / 2.3)
            } //GeometryReader
            GeometryReader { geometry in
                VStack {
                    ForEach(0..<images.count) { i in
                        if i % 2 != 0 {
                            GeometryReader { geometry in
                                let imageWidth = geometry.size.width
                                AsyncImageView(imageURL: $images[i])
                                    .cornerRadius(20)
                                    .frame(width: imageWidth)
                            }
                        }//if
                    }//ForEach
                }//VStack
                .padding(.leading, 10)
                .padding(.trailing, 20)
                .frame(height: geometry.size.height)
            }
        } //HStack
    }
}

struct TwoRowImageView_Previews: PreviewProvider {
    static var previews: some View {
        TwoRowImageView()
    }
}
