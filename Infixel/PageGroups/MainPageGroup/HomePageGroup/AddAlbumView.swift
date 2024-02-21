//
//  AddAlbumView.swift
//  Infixel
//
//  Created by 차상진 on 1/4/24.
//

import SwiftUI

//1. 첫화면
//-처음에 위로 슬라이드 했을때는 앨범리스트 중 두개만 나타낸다.
//-넓이는 기기사이즈의 넓이를 따라감.
//2. 한번 더 위로 슬라이드
//-처음에 나타났던 두개의 앨범은 유지하고 나머지 앨범의 갯수들이 나타난다.
//앨범의 갯수가 두개 이하일때는 유지

struct AddAlbumView: View {
    
    @Binding var albumList:[Album]
    
    @Binding var albumsOpen:Bool
    
    let _height = 800.0
    
    @State private var dragOffset: CGFloat = 0.0
    @Binding var addAlbumOffset : CGFloat
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Rectangle() //상단 핸들 모양
                        .frame(width: 40.0, height: 10)
                        .foregroundColor(Color(hexString: "F4F2F2"))
                        .cornerRadius(20)
                        .padding([.top, .bottom], 20)
                        .gesture(DragGesture()
                           .onChanged { value in
                               // Update dragOffset based on drag gesture
                               addAlbumOffset = value.translation.height + 300
                               print(addAlbumOffset)
                           }
                            .onEnded { value in
                                if addAlbumOffset > 350 {
                                    addAlbumOffset = 1000
                                    albumsOpen = false
                                } else if addAlbumOffset < 270 {
                                    addAlbumOffset = 300
                                }
                            }
                       )
                }//VStack
                .frame(width: geo.size.width, height: 50)
                .background(.white)
                
                
                
                
                HStack { //상단 페이지 이름 부분 - Add Albums
                    Text("Add Albums")
                        .font(Font.custom("Bungee-Regular", size: 27))
                        .foregroundColor(Color(hexString: "4657F3"))
                        
                    Spacer()
                }//VStack
                .padding([.leading], 20)
                .padding([.bottom, .top], 10)
                //.padding(15)
                //--Add Albums - HStack
                
                ScrollView() {
                    
                    ForEach($albumList) { album in
                        AddAlbum_singleAlbum_View(thumbnailLink: album.tumbnailLink, albumName: album.albumName)
                            .frame(width: geo.size.width, height: 120)
                    }
                }
                
            }//VStack
            .background(Color.white) // VStack에 배경색 설정
            .cornerRadius(40)
            .edgesIgnoringSafeArea(.all)
            
            
        }//GeometryReader
        
    }
}

//#Preview {
//    AddAlbumView()
//}
