//
//  LoginPage.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI

struct LoginPage: View {
    
    @Binding var isLoggedIn: Bool

    @State private var userId: String = ""
    @State private var userPW: String = ""
    
    @State var placeHolder_email:String = "E-mail"
    @State var placeHolder_pw:String = "Password"
    
    @State var secure:Bool = true
    @State var notSecure:Bool = false
    
    @ObservedObject var loginViewModel = LoginButtonViewModel()
    @ObservedObject var signupViewModel = SignUpViewModel()
    
    @State var images:[SearchSingleImage] = [
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                ImageGridView(images: $images)
                    .blur(radius: 15)
                
                //회색 blur 배경
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color(hexString: "898989", opacity: 0.7))
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
               
                    //ID
                    InputView(inputValue: $userId, placeHolder: $placeHolder_email, secure: $notSecure, loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel in
                        loginViewModel.userId = userId
                    }
                    .padding(.top, 15)
                    
                    //PW
                    InputView(inputValue: $userPW, placeHolder: $placeHolder_pw, secure: $secure, loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel in
                        loginViewModel.userPW = userPW
                    }
           
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
                    
                    
                    
                    LoginButtonView(viewModel: loginViewModel, isLoggedIn: $isLoggedIn)
                        .padding(.top, 70)
                    
                    
                    Spacer()
                    
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
            }
            
        }
    }
}

//#Preview {
//    LoginPage()
//}


