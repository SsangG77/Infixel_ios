//
//  LoginInputView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/16.
//

import SwiftUI

struct LoginInputView: View {
    
   
    @Binding var userID:String
    @Binding var userPW:String
    
    
    var body: some View {
        //ID
        VStack {
            HStack {
                Spacer().frame(width: 30)
                VStack {
                    ZStack(alignment: .leading) {
                        if userID.isEmpty {
                            Text("ID")
                            .bold()
                            .foregroundColor(
                                Color.white.opacity(0.6))
                            .padding()
                            .padding(.leading, 10)
                            .underline(true, color: .white.opacity(0.6))
                            .font(.system(size: 20))
                        }
                        TextField("", text: $userID)
                            .foregroundColor(
                                Color.white.opacity(0.6))
                                     .padding()
                                     .padding(.leading, 10)
                                     .frame(height: 60)
                    }
                }
                .overlay(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(.white, lineWidth: 5)
                   )
                .background(.black)
                .cornerRadius(25)
                Spacer().frame(width: 30)
            }
        }
        
        //PW
        VStack {
            HStack {
                Spacer().frame(width: 30)
                VStack {
                    ZStack(alignment: .leading) {
                        if userPW.isEmpty {
                            Text("Password")
                            .bold()
                            .foregroundColor(
                                Color.white.opacity(0.6))
                            .padding()
                            .padding(.leading, 10)
                            .underline(true, color: .white.opacity(0.6))
                            .font(.system(size: 20))
                        }
                        SecureField("", text: $userPW)
                            .foregroundColor(
                                Color.white.opacity(0.6))
                                     .padding()
                                     .padding(.leading, 10)
                                     .frame(height: 60)
                    }
                }
                .overlay(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(.white, lineWidth: 5)
                   )
                .background(.black)
                .cornerRadius(25)
                Spacer().frame(width: 30)
            }
        }
    }
}

//struct LoginInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginInputView()
//
//    }
//}
