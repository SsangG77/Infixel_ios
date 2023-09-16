//
//  LoginPage.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

struct LoginPage: View {
    

    
    var body: some View {
        ZStack {
            
            TwoRowImageView().blur(radius: 15)
            
            //회색 반투명 배경
            GeometryReader { geometry in
                Rectangle().fill(Color(UIColor(hexCode: "898989")).opacity(0.7))
                    .frame(height: geometry.size.height * 2)
                    .offset(y: -100)
            }//GeometryReader
          
            //로그인 페이지 타이틀
            VStack {
                Spacer()
                
                Text("INFIXEL")
                    .font(Font.custom("Bungee-Regular", size: 50))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                
                Spacer()
                
                LoginInputView()
                
                Spacer()
                
                //SNS Login
                HStack {
                    Image("Instagram_Glyph_Icon")
                        .resizable()
                    
                }
                
            }
            
            
            
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}


