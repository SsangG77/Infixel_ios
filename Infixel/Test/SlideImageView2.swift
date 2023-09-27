//
//  SlideImageView2.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/25.
//

import SwiftUI

struct SlideImageView2: View {
    
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
    
    @State var dragOffset:CGFloat = 0
    
    @State var materialToggle:Bool = false
    
    @State var currentIndex = 0
    
    var body: some View {
        @State var previousIndex = max(currentIndex - 1, 0)
        @State var nextIndex = min(currentIndex + 1, images.count - 1)
        
        
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height * 1.15
            
            ZStack {
                //previous image
                VStack {
                    ZStack {
                        
                        if materialToggle {
                            
                            AsyncImageView(imageURL: URL(string: images[previousIndex]))
                                .frame(width: width, height: height)
                            VStack {
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.7))
                                    .background(.ultraThickMaterial)
                                    .transition(.opacity) // 페이드 인 애니메이션 적용
                            }
                            
                        } else {
                            AsyncImageView(imageURL: URL(string: images[previousIndex]))
                                .frame(width: width, height: height)
                        }
                    }
                }
                .ignoresSafeArea()
                .offset(y : dragOffset - height)
              
                //middle image
                VStack {
                    ZStack {
                        
                        if materialToggle {
                            
                            AsyncImageView(imageURL: URL(string: images[currentIndex]))
                                .frame(width: width, height: height)
                            VStack {
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.7))
                                    .background(.ultraThickMaterial)
                                    .transition(.opacity) // 페이드 인 애니메이션 적용
                            }
                            
                        } else {
                            AsyncImageView(imageURL: URL(string: images[currentIndex]))
                                .frame(width: width, height: height)
                        }
                    }
                }
                .ignoresSafeArea()
                .offset(y : dragOffset)
               
                //next image
                VStack {
                    ZStack {
                        if materialToggle {
                            AsyncImageView(imageURL: URL(string: images[nextIndex]))
                                .frame(width: width, height: height)
                            VStack {
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.7))
                                    .background(.ultraThickMaterial)
                                    .transition(.opacity) // 페이드 인 애니메이션 적용
                            }
                            .onAppear {
                                print("on appear")
                                
                            }
                        } else {
                            AsyncImageView(imageURL: URL(string: images[nextIndex]))
                                .frame(width: width, height: height)
                        }
                        
                        
                    }
                }
                .ignoresSafeArea()
                .offset(y : dragOffset + height)
              
            }
            .ignoresSafeArea()
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.height
                        withAnimation(.easeIn(duration: 0.2)) {
                            materialToggle = true
                        }
                    }
                    .onEnded { gesture in
                        let threshold: CGFloat = 100
                        let gestureHeight = gesture.translation.height
                        
                        //손가락을 밑으로 슬라이드 -> 이전 이미지로 이동
                        if gestureHeight > threshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = height
                            }
                            if 0.0 == dragOffset - height {
                                
                            }
                             
                            
                        }
                        
                        
                        //손가락을 위로 슬라이드 -> 다음 이미지로 이동
                        //else
                        if gestureHeight < -threshold {
                            if #available(iOS 17.0, *) {
                                
                                withAnimation(.bouncy(duration: 0.5), {
                                    dragOffset = -height
                                }) {
                                    print("애니메이션 종료")
                                    
                                    dragOffset += height
                                    if dragOffset == 0.0 {
                                        
                                        withAnimation {
                                            
                                            materialToggle = false
                                        }
                                    } //dragOffset == 0.0
                                } //withAnimation
                            } //#available(ios 17.0)
                            else {}
                            
                            currentIndex = nextIndex
                            
                        }  //gestureHeight < -height
                        else {
                            //withAnimation {
                                dragOffset = 0
                                materialToggle = false
                            
                            //}
                        }
                    }
            )
        }
    }//body
}

#Preview {
    SlideImageView2()
}

