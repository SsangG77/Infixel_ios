//
//  SignInView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/21.
//

import SwiftUI

struct SignUpView: View {
    
    
    @State var userEmail             :String = ""
    @State var userPW                :String = ""
    @State var confirmPW             :String = ""
    
    //placeHolder
    @State var placeHolder_email     :String = "E-Mail"
    @State var placeHolder_pw        :String = "Password"
    @State var placeHolder_confirm_pw:String = "Confirm Password"
    
    //secure
    @State var secure                :Bool   = true
    @State var notSecure             :Bool   = false
    
    //알림 변수
    @State var alert                 :Bool   = false
    
    
    var body: some View {
        ZStack {
            TwoRowImageView().blur(radius: 15)
            
            //회색 blur 배경
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color(UIColor(hexCode: "898989"))
                    .opacity(0.7))
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
                
                    
                    InputView(inputValue: $userEmail, placeHolder: $placeHolder_email, secure: $notSecure)
                        .padding(.bottom, 10)
                        .padding(.top, 75)
                    
                    InputView(inputValue: $userPW, placeHolder: $placeHolder_pw, secure: $secure)
                        .padding(.bottom, 10)
                    
                    InputView(inputValue: $confirmPW, placeHolder: $placeHolder_confirm_pw, secure: $secure)
                    

                
                
                Button(action: {
                    print("회원가입 버튼")
                    if !isValidEmail(userEmail) || userPW != confirmPW {
                        alert = true
                    } else {
                        alert = false
                    }
                    
                               
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
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text("알림"),
                        message: Text("이메일, 비밀번호를 확인해주세요."),
                        dismissButton: .default(Text("확인"))
                    )
                }
                

                
                
            }//VStack
                    
        }//ZStack
        
    }//body
}

//이메일 형식이면 true, 아니면 false
func isValidEmail(_ email: String) -> Bool {
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    if let regex = try? NSRegularExpression(pattern: emailPattern) {
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = regex.numberOfMatches(in: email, options: [], range: range)
        return matches > 0
    }
    
    return false
}





#Preview {
    SignUpView()
}
