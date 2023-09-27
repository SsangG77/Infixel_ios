//
//  SignInView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/21.
//

import SwiftUI

struct RegisterView: View {
    
    
    @State var userEmail:String = ""
    @State var userPW:String = ""
    @State var confirmPW:String = ""
    
    //placeHolder
    @State var placeHolder_email:String = "E-Mail"
    @State var placeHolder_pw:String = "Password"
    @State var placeHolder_confirm_pw:String = "Confirm Password"
    
    //secure
    @State var secure:Bool = true
    @State var notSecure:Bool = false
    
    // 애니메이션을 위한 상태 변수
    @State private var isMatched = true
    
    
    var body: some View {
        ZStack {
            TwoRowImageView().blur(radius: 15)
            
            //회색 blur 배경
            GeometryReader { geometry in
                Rectangle().fill(Color(UIColor(hexCode: "898989")).opacity(0.7))
                    .frame(height: geometry.size.height * 2)
                    .offset(y: -100)
            }//GeometryReader
            
            VStack {
                
                
                Text("Sign up")
                    .font(Font.custom("Bungee-Regular", size: 50))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    //.padding(.top, 10)
                    
                //Spacer()
                
                VStack {
                    
                    InputView(inputValue: $userEmail, placeHolder: $placeHolder_email, secure: $notSecure)
                        .padding(.bottom, 10)
                        .padding(.top, 75)
                    
                    InputView(inputValue: $userPW, placeHolder: $placeHolder_pw, secure: $secure)
                        .padding(.bottom, 10)
                    
                    InputView(inputValue: $confirmPW, placeHolder: $placeHolder_confirm_pw, secure: $secure)
                    
                    
                }
                
                
                
                Button(action: {
                                print("회원가입 버튼 뷰")
                               
                }) {
                    Text("sign up")
                        .font(Font.custom("Bungee-Regular", size: 18))
                        .foregroundColor(Color(UIColor(hexCode: "202FB4")))
                        .padding(.leading, 60)
                        .padding(.trailing, 60)
                        .padding(13)
                        .background(Color(UIColor(hexCode: "ABB2F2")))
                        .cornerRadius(30)
                }
                .padding(.top, 50)

                
                
                
            }//VStack
                    
        }//ZStack
        
    }//body
    
    /*
    텍스트 애니메이션이 나타나야되는 경우
     1. password 있고 confirm 없을때 -> confirm에 입력될 때
     2. confirm 있고 password 없을때 -> password에 입력될 때
     3. 둘 다 다를때                 -> 둘 다 맞을 때
     4. 둘 다 맞을 때                -> 둘 다 다를 때
     5, 둘 다 없을 때                -> 둘 중 하나라도 입력될 때
    */

    private func checkPasswordMatch() {
            if !userPW.isEmpty && !confirmPW.isEmpty {
                if userPW == confirmPW {
                    withAnimation {
                        isMatched = true
                    }
                } else {
                    withAnimation {
                        isMatched = false
                    }
                }
            } else {
                withAnimation {
                    isMatched = false
                }
            }
        }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}





#Preview {
    RegisterView()
}
