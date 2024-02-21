//
//  LoginPage.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

struct LoginPage: View {
    
    @Binding var isLoggedIn: Bool
    
    //프리뷰용 변수
    //@State var isLoggedIn = false
    
    @State private var userId: String = ""
    @State private var userPW: String = ""
    

    
    var body: some View {
        NavigationView {
            ZStack {
                
                TwoRowImageView().blur(radius: 15)
                
                //회색 blur 배경
                GeometryReader { geometry in
                    Rectangle().fill(Color(UIColor(hexCode: "898989")).opacity(0.7))
                        .frame(height: geometry.size.height * 2)
                        .offset(y: -100)
                }//GeometryReader
                
                
                VStack {
                    //Spacer()
                    
                    //로그인 페이지 타이틀
                    Text("INFIXEL")
                        .font(Font.custom("Bungee-Regular", size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 60)
                        .padding(.top, 140)
               
              
                    LoginInputView(userId: $userId, userPW: $userPW)
                        .padding(.top, 15)
           
                    //회원가입
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .underline()
                            .font(Font.custom("Bungee-Regular", size: 12))
                            .padding(.top, 5)
                            
                    }
                    
                  
                    //SNS Login
                    SNSLoginView()
                        .padding(.top, 30)
                    
                    
                    
                    LoginButtonView(isLoggedIn : $isLoggedIn, userId: $userId, userPW: $userPW)
                        .padding(.top, 70)
                    
                    
                    Spacer()
                    
                    
                    
                }
                
            }
            
        }
    }
}

//struct LoginPage_Previews: PreviewProvider {
//   static var previews: some View {
//        LoginPage()
//    }
//}


