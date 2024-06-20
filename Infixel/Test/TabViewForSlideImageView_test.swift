//
//  TabViewForSlideImageView_test.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/27.
//

import SwiftUI

struct TabViewForSlideImageView_test: View {
    
    @State var images:[String] = [
        "https://pbs.twimg.com/media/FpeiX-yaAAEEG6J?format=jpg",
        
        
    ]
    
    @State var links = [
        "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2022/06/15/ebcf24c6-8c5e-4b9c-bc44-44010e91745a.jpg",
        "https://i2.tcafe2a.com/230702/thumb-00c7090b30a08df66089fe0d7d036b92_1688268591_5081_835x1041.jpg",
        "https://image5jvqbd.fmkorea.com/files/attach/new3/20230609/3655109/3035547727/5851858710/c228b8ea29d0fcefee7fabe868a037a1.jpeg",
        "https://res.heraldm.com/phpwas/restmb_jhidxmake.php?idx=5&simg=202111042118469934178_20211104211913_01.jpg",
        "https://file3.instiz.net/data/file3/2023/05/26/3/9/1/39170b65f9dd832bae8fe204cc7278d5.jpg",
        "https://cdn.newsculture.press/news/photo/202207/509775_619054_128.jpg",
        "https://upload3.inven.co.kr/upload/2023/03/23/bbs/i14867368378.jpg",
        "https://mblogthumb-phinf.pstatic.net/MjAyMzA1MjNfODgg/MDAxNjg0ODE0Njg4NDQ5.jIf9krRY6BpalF6EJFE6J5lsDnaxERh7psCaZ5YQj3Ag.rhFmO_36eiEW9f9KAndKjxU6vIsr1dR2rfMatDhcjPYg.JPEG.xnvely/IMG_1497.JPG?type=w800",
        "https://blog.kakaocdn.net/dn/cdIpOF/btraLtyJfOR/jScbsgfSCOy6rDEJMyxr9K/img.jpg",
        "https://i1.ruliweb.com/img/22/07/29/1824989742f853a3.jpg",
    ]
    
    
    @State var currentImageLink = ""
    
    
    var body: some View {
        GeometryReader { geo in
            
            let width = geo.size.width
            let height = geo.size.height
           
            TabView(selection: $currentImageLink) {
                ForEach($images, id: \.self) { $image in
                    VStack {
                        AsyncImageView(imageURL: $image)
                            .frame(width: width, height: height)
                    }
                    .rotationEffect(Angle(degrees: -90))
                    .frame(height: height)
                    //.tag(image.id)
                    .onAppear {
                        print("on appear : ", image)
                        
                        if let randomLink = links.randomElement() {
                            images.append(randomLink)
                        }
                        
                        
                    }
                    .onDisappear {

                        print("on disappear")
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .rotationEffect(Angle(degrees: 90))
            .frame(width: height)
            .offset(x: -height/4)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .background(.black.opacity(0.3))
        .onAppear {
            //전체 뷰가 그려질 때 랜덤으로 이미지를 가져옴
            currentImageLink = images.first ?? ""
            if let randomLink = links.randomElement() {
                images.append(randomLink)
            }
        }
    }
}

#Preview {
    TabViewForSlideImageView_test()
}
