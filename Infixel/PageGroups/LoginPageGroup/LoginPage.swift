//
//  LoginPage.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

struct LoginPage: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var userID: String = ""
    @State private var userPW: String = ""
    

    
    var body: some View {
        ZStack {
            
            TwoRowImageView().blur(radius: 15)
            
            //회색 blur 배경
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
                    .padding(.bottom, 60)
                
                
                LoginInputView(userID: $userID, userPW: $userPW)
                    .padding(.top, 15)
                
                //SNS Login
                SNSLoginView()
                    .padding(.top, 30)
                
                
                
                LoginButtonView(isLoggedIn : $isLoggedIn, userID: $userID, userPW: $userPW)
                    .padding(.top, 20)
                
                
                Spacer()
                
                
                
            }
            
            
            
        }
    }
}

//struct LoginPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginPage()
//    }
//}


