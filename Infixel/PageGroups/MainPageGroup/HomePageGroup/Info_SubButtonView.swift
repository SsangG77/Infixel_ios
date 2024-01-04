//
//  Info_SubButtonView.swift
//  Infixel
//
//  Created by 차상진 on 10/24/23.
//

import SwiftUI

struct Info_SubButtonView: View {
    
    var cornerRadius = 18.0
    
    @State var arrowBtnState = true
    //@Binding var arrowBtnState:Bool
    
    @State var slideImage: SlideImage = SlideImage(link: "", pic: 32, description: "test", user: User(user_nick: "sang_ji", thumbnail_link: "http://localhost:3000/randomjpg"))
    //@Binding var slideImage: SlideImage
    
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.1))
                        .background(.ultraThinMaterial)
                        
                    HStack {
                        if arrowBtnState {
                            //버튼을 눌렀을때 들어갈 뷰
                            HStack {
                                VStack { //프로필, 닉네임 키우기
                                    VStack {
                                        AsyncImageView(imageURL: URL(string: slideImage.uploader.thumbnail_link))
                                            .cornerRadius(200)
                                            
                                        
                                    }//VStack - 프로필 사진 확대
                                    .frame(width: 60, height: 60)
                                    .padding(.bottom, 5)
                        
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        Text("@" + slideImage.uploader.user_nick)
                                            .font(Font.custom("Bungee-Regular", size: 11))
                                            .foregroundColor(.white) // - 닉네임
                                    }
                                        
                                }//VStack - 프로필, 닉네임 확대
                                .frame(width: 70)
                                
                                VerticalLine()
                                    .stroke(Color(hexString: "404040"), lineWidth: 2)
                                    .frame(width: 2, height: 185) // - 세로선
                                
                                VStack { //사진 설명, 태그들
                                    if slideImage.description.count > 25 {
                                        ScrollView {
                                            VStack {
                                                Text(slideImage.description)
                                                    .font(Font.custom("Bungee-Regular", size: 13))
                                                    //.font(.system(size: 14))
                                                
                                            }
                                            
                                        }
                                        .padding(.top, 17)
                                        .frame(height: 120)
                                        
                                    } else {
                                        Text(slideImage.description)
                                            .font(.system(size: 17))
                                            .padding(.top, 17)
                                    } // - 사진 설명글
                                    Spacer()
                                    
                                    //태그들 여기 표시
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach($slideImage.tags, id: \.self) {$tag in
                                                ZStack {
                                                    
                                                Rectangle()
                                                    .frame(width: CGFloat(tag.count)*10 + 10, height: 20)
                                                    .foregroundColor(Color(hexString: "404040"))
                                                    .cornerRadius(7)
                                                Text(tag)
                                                        .font(.system(size:12))
                                                        .foregroundColor(.white)
                                                }
                                                
                                            }//ForEach
                                        }//HStack
                                        .padding(.bottom, 17)
                                    }//ScrollView
                                    //.padding(.bottom, 10)
                                    
                                }//VStack
                                .frame(width: 150)
                                .clipped()
                                .padding([.top, .bottom], 13) // - 사진 설명글, 태그
                            }//HStack
                        }//if - 펼쳐졌을때
                        else {
                            HStack {
                                VStack {
                                    AsyncImageView(imageURL: URL(string : slideImage.uploader.thumbnail_link))
                                        .cornerRadius(200)
                                    
                                }//VStack
                                .frame(width: 25, height: 25)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    Text("@" + slideImage.uploader.user_nick)
                                        .font(Font.custom("Bungee-Regular", size: 12))
                                        .foregroundColor(.white)
                                }
                            }
                        }//else
                        
                        Spacer()
                        withAnimation {
                        Image(arrowBtnState ? "arrow_left" : "arrow_right")
                                .frame(width: 10, height: 10)
                                .onTapGesture {
                                    withAnimation {
                                        arrowBtnState.toggle()
                                    }//withAnimation
                                }//onTapGesture
                        }//withAnimation
                    }//HStack
                    .padding([.leading, .trailing], 20)
                    
                }
                .frame(width : arrowBtnState ? geo.size.width * 0.8 : geo.size.width * 0.45, height: arrowBtnState ? 230 : 50)
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                Spacer()
                
                ZStack {
                    VStack {
                        Rectangle()
                            .foregroundColor(.secondary.opacity(0.1))
                            .background(.ultraThinMaterial)
                    }
                    
                    if arrowBtnState { //세로 일때
                        VStack {
                            let padding = EdgeInsets(top: 8, leading:0, bottom: 8, trailing: 0)
                            let size = 23.0
                            
                            Spacer()
                            VStack {
                                
                                IconView(imageName: "pic!", size: size, padding: EdgeInsets(top: 9, leading:0, bottom: 2, trailing: -2)) {
                                    print("+1")
                                }
                                Text(String(slideImage.pic)).font(.system(size: 11)).foregroundColor(.white)
                            }
                            .padding(.bottom, 5)
                            VStack {
                                
                                IconView(imageName: "comments", size: size, padding: EdgeInsets(top: 9, leading:0, bottom: 2, trailing: 0)) {
                                    print("+1")
                                }
                                Text("56").font(.system(size: 11)).foregroundColor(.white)
                                
                            }
                            .padding(.bottom, 5)
                            
                            
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                print("+1")
                            }
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                print("+1")
                            }
                            
                            Spacer()
                            
                        }
                        .padding([.top, .bottom], 5)
                    } else { //가로 일때
                        HStack {
                            let padding = EdgeInsets(top: 0, leading:6, bottom: 0, trailing: 6)
                            let size = 21.0
                            
                            IconView(imageName: "pic!", size: size, padding: padding) {
                                print("+1")
                            }
                            IconView(imageName: "comments", size: size, padding: padding) {
                                print("+1")
                            }
                            IconView(imageName: "add albums", size: size, padding: padding) {
                                print("+1")
                            }
                            IconView(imageName: "three dots", size: size, padding: padding) {
                                print("+1")
                            }
                        }
                    }
                    
                }
                .frame(width: arrowBtnState ? geo.size.width * (0.95 - 0.8) : geo.size.width * (0.95 - 0.45), height: arrowBtnState ? 230 : 50)
                .cornerRadius(arrowBtnState ? 16.0 : cornerRadius)
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .frame(width: geo.size.width, height: 300, alignment: .bottom)
        }
    }
    
    
    struct VerticalLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            return path
        }
    }
    
    
}


#Preview {
    Info_SubButtonView()
}
