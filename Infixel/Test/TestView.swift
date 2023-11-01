//
//  TestView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/27.
//

import SwiftUI

struct TestView: View {
    
    
    @State var images:[String] = [
        "https://pbs.twimg.com/media/FpeiX-yaAAEEG6J?format=jpg",
        "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/06/15/ebcf24c6-8c5e-4b9c-bc44-44010e91745a.jpg",
        "https://i2.tcafe2a.com/230702/thumb-00c7090b30a08df66089fe0d7d036b92_1688268591_5081_835x1041.jpg",
        "https://image5jvqbd.fmkorea.com/files/attach/new3/20230609/3655109/3035547727/5851858710/c228b8ea29d0fcefee7fabe868a037a1.jpeg",
        "https://res.heraldm.com/phpwas/restmb_jhidxmake.php?idx=5&simg=202111042118469934178_20211104211913_01.jpg",
        "https://file3.instiz.net/data/file3/2023/05/26/3/9/1/39170b65f9dd832bae8fe204cc7278d5.jpg",
        "https://cdn.newsculture.press/news/photo/202207/509775_619054_128.jpg",
        "https://upload3.inven.co.kr/upload/2023/03/23/bbs/i14867368378.jpg",
    ]
    
    
    var body: some View {
            AsyncImageView(imageURL: URL(string:  images[0]))
    }
}

#Preview {
    TestView()
}
