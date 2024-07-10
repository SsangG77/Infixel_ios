//
//  LoginButtonView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI

struct LoginButtonView: View {
    @ObservedObject var viewModel: LoginButtonViewModel
    
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        Button {
            viewModel.sendTextToServer($isLoggedIn)
        } label: {
            Text("Login")
             .font(Font.custom("Bungee-Regular", size: 18))
             .foregroundColor(Color(hexString: "202FB4"))
             .padding(.leading, 60)
             .padding(.trailing, 60)
             .padding(13)
             .background(Color(hexString: "ABB2F2"))
             .cornerRadius(30)
        }//label
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("로그인 실패"),
                message: Text("ID, Password를 확인하세요."),
                dismissButton: .default(Text("확인"))
            )//Alert
        }//alert
    }//body
}


