//
//  LoginButtonView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI

struct LoginButtonView: View {
    
    @Binding var isLoggedIn: Bool

    @Binding var userID:String
    @Binding var userPW:String
    @State var showAlert = false
    
    
    var body: some View {
        Button(action: {
                        print("로그인 버튼 뷰")
                        print("ID : ", userID)
                        print("PW : ", userPW)
                        if userID == "test" && userPW == "test" { //로그인 성공했을때
                            isLoggedIn = true
                        } else {                                  //로그인 실패했을때
                            showAlert = true
                            
                        }
                    }) {
                        Text("Login")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(UIColor(hexCode: "202FB4")))
                            .padding(.leading, 60)
                            .padding(.trailing, 60)
                            .padding(13)
                            .background(Color(UIColor(hexCode: "ABB2F2")))
                            .cornerRadius(30)
                        
                    }
                    .alert(isPresented: $showAlert) {
                        
                                Alert(
                                    title: Text("알림"),
                                    message: Text("아이디, 비밀번호를 확인해주세요."),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
    }
}
//
//struct LoginButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginButtonView()
//    }
//}
