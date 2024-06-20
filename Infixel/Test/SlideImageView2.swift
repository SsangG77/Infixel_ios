//
//  SlideImageView2.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/25.
//

import SwiftUI

struct SlideImageView2: View {
    
    @State var slideImages: [SlideImage] = []
    @State var infoBoxReset = false
    
    @State private var selectedTabIndex = 0
    
 
    
    @State var slideImage:SlideImage = SlideImage()
    
    var body: some View {
        
            ZStack(alignment: .topTrailing) {
                GeometryReader { geo in
                    
                    let width = geo.size.width
                    let height = geo.size.height
                TabView(selection : $selectedTabIndex) {
                    ForEach(
                    //$slideImages,
                    0..<slideImages.count, id: \.self
                    ) { i in
                        VStack {
                            AsyncImageView(imageURL: $slideImages[i].link)
                                .frame(width: width, height: height)
                        }
                        .rotationEffect(Angle(degrees: -90))
                        .frame(height: height)
                
                    } //ForEach
                } //TabView
                .tabViewStyle(.page(indexDisplayMode: .never))
                .rotationEffect(Angle(degrees: 90))
                .frame(width: height)
                .offset(x: -height/4)
                .ignoresSafeArea()
                .onChange(of: selectedTabIndex) { newTab in
                    // 선택된 탭이 마지막 탭인지 확인
                    if newTab == slideImages.count - 1
                        //|| newTab == slideImages.count - 2
                    {
                        // 마지막 탭에 도달했을 때 실행할 함수 호출
                        //reqImage()
                    }
                    slideImage = slideImages[selectedTabIndex]
                }//TabView - onChange
               
                //===========================================TabView=============================================
                
                
                } //GeometryReader
            
            }//Zstack
        .ignoresSafeArea()
        .background(.white.opacity(0.3))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
              
                // 배열에 값이 두 개가 되면 타이머 정지
                if slideImages.count > 2 {
                    timer.invalidate()
                } else {
                    //reqImage()
                }
            }//Timer.scheduledTimer
        }//onAppear - GeometryReader
    }//body
}

#Preview {
    SlideImageView2()
}

