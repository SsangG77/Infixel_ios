//
//  new_InfoSubButtonView.swift
//  Infixel
//
//  Created by 차상진 on 6/29/24.
//

import SwiftUI

struct new_InfoSubButtonView: View {
    
    var cornerRadius = 18.0
   
    @EnvironmentObject var appState: AppState
    //@Binding var slideImage: SlideImage
    @State var slideImage: SlideImage = SlideImage()
    
    //info
    @State var pic_count = 0
    @State var user_nick = ""
    @State var thumbnail = ""
    
    @State var pic_result = false
    @State var pic_image_name = "pic down"
    @State var tags:[String] = []
    
    //화면 크기
    let width_ = UIScreen.main.bounds.width
    let height_ = UIScreen.main.bounds.height
    
    
    
    
    var body: some View {
       
        
        HStack {
            
            HStack {
                //프로필, 닉네임 같이 있는 부분 ===================================
                VStack {
                    AsyncImageView(imageURL: $thumbnail)
                        //.cornerRadius(200)
                }
                .frame(
                    width: appState.infoBoxReset ? 60 : 25,
                    height: appState.infoBoxReset ? 60 : 25
                )
                .cornerRadius(200)
                .padding(.bottom, appState.infoBoxReset ? 5 : 0)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    Text("@" + user_nick)
                        .font(Font.custom("Bungee-Regular", size: appState.infoBoxReset ? 11 : 12))
                        .foregroundColor(.white)
                }//ScrollView
                
            }//HStack
        }//HStack
        
        
        
        
    }
}

#Preview {
    new_InfoSubButtonView()
}
