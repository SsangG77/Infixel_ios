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
    
    @State private var selectedTabIndex = 0
    
    //@State private var albumsOpen = false
    @Binding var albumsOpen:Bool
    @Binding var addAlbumOffset : CGFloat
    
    var body: some View {
        
            
            ZStack(alignment: .topTrailing) {
                GeometryReader { geo in
                    
                    let width = geo.size.width
                    let height = geo.size.height
                TabView(selection : $selectedTabIndex) {
                    ForEach(
                    //$slideImages,
                    0..<slideImages.count, id: \.self) { i in
                        VStack {
                            AsyncImageView(imageURL: URL(string: slideImages[i].link))
                                .frame(width: width, height: height)
                        }
                        .rotationEffect(Angle(degrees: -90))
                        .frame(height: height)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                infoBoxReset = false
                            } //withAnimation
                            print("AsyncImageView - VStack .onAppear ===================== [\(slideImages[i].description)] 사진 갯수 : \(slideImages.count) ")
                            reqImage()
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
                    if newTab == slideImages.count - 1 || newTab == slideImages.count - 2 {
                        // 마지막 탭에 도달했을 때 실행할 함수 호출
                        print("TabView - onChange ============================== 마지막 탭 도달")
                        reqImage()
                    } else {
                        print("TabView - onChange ============================== 숫자가 달라, 현재 탭 번호 : \(newTab), 이미지 번호 : \(slideImages.count) ")
                    }
                }//TabView - onChange
                //===========================================TabView=============================================
                VStack {
                    Spacer()
                    if slideImages.count > 0 {
                        //Info_SubButtonView()
                        Info_SubButtonView(
                            arrowBtnState: $infoBoxReset,
                            slideImage: $slideImages[selectedTabIndex],
                            albumsOpen : $albumsOpen,
                            addAlbumOffset : $addAlbumOffset
                        )
                    
                        .frame(width: width - 34, height: 300, alignment: .bottom)
                        .padding([.leading, .trailing], 17)
                    }
                    Spacer().frame(height: 120)
                }//VStack
                .frame(width: height, height: height, alignment: .leading)
                //======================================info_SubButtonView===================================
                
                } //GeometryReader
                
                ZStack {
                    if albumsOpen {
                            Rectangle()
                                .foregroundColor(.secondary.opacity(0.1))
                                .background(.ultraThinMaterial)
                                .transition(.opacity)
                                .opacity(albumsOpen ? 1.0 : 0.0)
                                .animation(.easeInOut)
                                .onTapGesture {
                                    withAnimation {
                                        albumsOpen = false
                                        addAlbumOffset = 1000
                                    }
                                }
                    }
                    
                }//ZStack - add album
            }//Zstack
        .ignoresSafeArea()
        .background(.white.opacity(0.3)) // <- 여기에 로딩 이미지 넣어야함
        .onAppear {
            print("   ")
            print("===================================최초 로딩 뷰===================================")
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
                // 배열에 값을 추가
                print("GeometryReader .onAppear ============================== 초기 값 추가됨, slideImages.count : \(slideImages.count)")
                reqImage()
                // 배열에 값이 두 개가 되면 타이머 정지
                if slideImages.count == 2 {
                    timer.invalidate()
                }
            }//Timer.scheduledTimer
        }//onAppear - GeometryReader
    }//body
    
    
    
    
    
    
    
    
    
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
                                let userNick = uploaderData["user_nick"],
                                let userThumbNail = uploaderData["thumbnail_link"] {
                               let newSlideImage = SlideImage(link: link, pic: pic, description: description, user: User(user_nick: userNick, thumbnail_link: userThumbNail))
                               slideImages.append(newSlideImage)
                               print("reqImage() ============================================ slideImages 배열에  이미지 추가")
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


    


//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageView()
//    }
//}
