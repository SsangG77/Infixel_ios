//
//  LoginInputView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/16.
//

import SwiftUI

struct LoginInputView: View {
    
   
    @Binding var userId:String
    @Binding var userPW:String
    
    @State var placeHolder_email:String = "E-mail"
    @State var placeHolder_pw:String = "Password"
    
    @State var secure:Bool = true
    @State var notSecure:Bool = false
    
    
    var body: some View {
        //ID
        InputView(inputValue: $userId, placeHolder: $placeHolder_email, secure: $notSecure)
        
        //PW
        InputView(inputValue: $userPW, placeHolder: $placeHolder_pw, secure: $secure)
    }
}

//struct LoginInputView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        LoginInputView()
//
//    }
//}
