//
//  HomePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI
import Foundation

struct HomePageView: View {
    
    
    @State var slideImages: [SlideImage] = []
    @State var infoBoxReset = false
    
    @State var currentSlideImage = SlideImage(link: "", pic : 0, description: "", user: User(user_nick: ""))
    
    @State private var selectedTabIndex = 0
    
    var body: some View {
        
        GeometryReader { geo in
            
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack(alignment: .topTrailing) {
                TabView(selection : $selectedTabIndex) {
                ForEach(
                    //$slideImages,
                    0..<slideImages.count,
                    id: \.self) { i in
                        VStack {
                            AsyncImageView(imageURL: URL(string: slideImages[i].link))
                                .frame(width: width, height: height)
                        }
                        .rotationEffect(Angle(degrees: -90))
                        .frame(height: height)
                        .onAppear {
                            print(slideImages[i].description + ", 사진 갯수 :" + String(slideImages.count))
                            withAnimation(.easeInOut(duration: 0.5)) {
                                infoBoxReset = false
                            } //withAnimation
                        }//onAppear - VStack
                } //ForEach
            } //TabView
            .tabViewStyle(.page(indexDisplayMode: .never))
            .rotationEffect(Angle(degrees: 90))
            .frame(width: height)
            .offset(x: -height/4)
            .ignoresSafeArea()
            .onChange(of: selectedTabIndex) { newTab in
                        // 선택된 탭이 마지막 탭인지 확인
                        if newTab == slideImages.count - 1 {
                            // 마지막 탭에 도달했을 때 실행할 함수 호출
                            print("진짜 마지막 탭")
                            reqImage()
                        }
                    }
                
                VStack {
                    Spacer()
                    if slideImages.count > 0 {
                        
                        Info_SubButtonView(arrowBtnState: $infoBoxReset, slideImage: $slideImages[selectedTabIndex])
                        
                            .frame(width: width - 34, height: 300, alignment: .bottom)
                            .padding([.leading, .trailing], 17)
                    }
                    Spacer().frame(height: 120)
                    
                }//VStack
                .frame(width: height, height: height, alignment: .leading)
               
            }//Zstack
           
        } //GeometryReader
        .ignoresSafeArea()
        .background(.white.opacity(0.3)) // <- 여기에 로딩 이미지 넣어야함
        .onAppear {
            reqImage()
            reqImage()
        }//onAppear - GeometryReader
    }
    
    
    func reqImage() {
        let serverURL = URL(string: "http://localhost:3000/randomimage")!
        
        let task = URLSession.shared.dataTask(with: serverURL) { (data, response, error) in
            if let error = error {
                print("요청 중 오류 발생: \(error)")
            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                if let data = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           if   let link = json["link"] as? String,
                                let pic = json["pic"] as? Int,
                                let description = json["description"] as? String,
                                let uploaderData = json["uploader"] as? [String: String],
                                let userNick = uploaderData["user_nick"] {
                               let newSlideImage = SlideImage(link: link, pic: pic, description: description, user: User(user_nick: userNick))
                               slideImages.append(newSlideImage)
                           }//if let link, pic, description ...
                       }//if let json
                    } catch {
                        print("error : \(error)")
                    }//catch
                }//if let data
            }
        }//task
        task.resume()
    }
}


    


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
