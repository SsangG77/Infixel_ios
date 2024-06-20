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
    
    @Binding var commentsOpen:Bool
    @Binding var commentsOffset: CGFloat
    
    @Binding var slideImage:SlideImage
    
    var body: some View {
        
            ZStack(alignment: .topTrailing) {
                GeometryReader { geo in
                    
                    let width = geo.size.width
                    let height = geo.size.height
                TabView(selection : $selectedTabIndex) {
                    
                    
//                    ForEach($slideImages) { $slideImage in
//                        VStack {
//                            AsyncImageView(imageURL: $slideImage.link)
//                                .frame(width: width, height: height)
//                        }
//                        .rotationEffect(Angle(degrees: -90))
//                        .frame(height: height)
//                        //.tag(slideImage.id)
//                        .onAppear {
//                            withAnimation(.easeInOut(duration: 0.5)) {
//                                infoBoxReset = false
//                            } //withAnimation
//                       
//                            reqImage()
//                        }//onAppear - VStack
//                    } //ForEach
                    
                    ForEach( 0..<slideImages.count, id: \.self) { i in
                        VStack {
                            AsyncImageView(imageURL: $slideImages[i].link)
                                .frame(width: width, height: height)
                        }
                        .rotationEffect(Angle(degrees: -90))
                        .frame(height: height)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                infoBoxReset = false
                            } //withAnimation
                       
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
                    VarCollectionFile.myPrint(title: "tabView - onChange", content: "test")
                    // 선택된 탭이 마지막 탭인지 확인
                    if newTab == slideImages.count - 1 
                        //|| newTab == slideImages.count - 2
                    {
                        // 마지막 탭에 도달했을 때 실행할 함수 호출
                        reqImage()
                    }
                    slideImage = slideImages[selectedTabIndex]
                }//TabView - onChange
               
                //===========================================TabView=============================================
                    
                    
                    
                VStack {
                    Spacer()
                    if slideImages.count > 0 {
                        Info_SubButtonView(
                            arrowBtnState: $infoBoxReset,
                            slideImage: $slideImages[selectedTabIndex],
                            albumsOpen : $albumsOpen,
                            addAlbumOffset : $addAlbumOffset,
                            commentsOpen: $commentsOpen,
                            commentsOffset: $commentsOffset
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
                    if albumsOpen || commentsOpen {
                            Rectangle()
                                .foregroundColor(.secondary.opacity(0.1))
                                .background(.ultraThinMaterial)
                                .transition(.opacity)
                                .opacity(albumsOpen || commentsOpen ? 1.0 : 0.0)
                                .onTapGesture {
                                    withAnimation {
                                        albumsOpen = false
                                        commentsOpen = false
                                        addAlbumOffset = 1000
                                        commentsOffset = 1000
                                    }
                                }
                    }
                    
                }//ZStack - add album
            }//Zstack
        .ignoresSafeArea()
        .background(.white.opacity(0.3))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
              
                // 배열에 값이 두 개가 되면 타이머 정지
                if slideImages.count > 2 {
                    timer.invalidate()
                } else {
                    reqImage()
                }
            }//Timer.scheduledTimer
        }//onAppear - GeometryReader
    }//body
    
    
    func reqImage() {
        let serverURL = URL(string: VarCollectionFile.randomImageURL)!
        
        let task = URLSession.shared.dataTask(with: serverURL) { (data, response, error) in
            if let error = error {
                print("요청 중 오류 발생: \(error)")
            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                if let data = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           if let id = json["id"] as? String,
                              let imageFileName = json["image_link"] as? String,
                              let pic = json["pic"] as? Int,
                              let description = json["description"] as? String,
                              let userNick = json["user_at"] as? String,
                              let userProfileImage = json["profile_image"] as? String
                            {
                               let newSlideImage = SlideImage(id:id, link: imageFileName, pic: pic, description: description, user_nick: userNick, profile_image: userProfileImage)
                               if slideImages.count == 0 {
                                   slideImage = newSlideImage
                               }
                               withAnimation {
                                   slideImages.append(newSlideImage)
                               }
                           }//if let link, pic, description ...
                       }//if let json
                    } catch {
                        print("error : \(error)")
                    }//catch
                }//if let data
            }
        }//task
        task.resume()
    }//reqImage
    
    
}//HomePageView


    


//struct HomePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePageView()
//    }
//}
