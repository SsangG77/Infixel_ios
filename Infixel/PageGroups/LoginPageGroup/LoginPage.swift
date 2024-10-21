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
    
    @State private var showTermsPopup = true
    
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
                    SNSLoginView(isLoggedIn: $isLoggedIn)
                        .padding(.top, 30)
                    
                    
                    
                    LoginButtonView(viewModel: loginViewModel, isLoggedIn: $isLoggedIn)
                        .padding(.top, 70)
                    
                    Spacer()
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                if showTermsPopup && UserDefaults.standard.bool(forKey: "약관_동의") != true {
                    TermsPopupView(isPresented: $showTermsPopup)
                }
                
            }
            
            
        }
    }
}


struct TermsPopupView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("사용자 약관")
                .font(.headline)
                .padding()

            // 약관 내용 추가
            ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("# 최종 사용자 라이선스 계약 (EULA)")
                                .padding(.bottom, 10)

                            Text("이 최종 사용자 라이선스 계약(이하 \"계약\")은 [infixel](이하 \"소프트웨어\")의 사용을 규정합니다. 본 소프트웨어를 설치하거나 사용하기 전에 이 계약을 주의 깊게 읽어 주십시오.")

                            Text("## 1. 라이선스 부여")
                            Text("본 계약에 따라, 회사는 귀하에게 비독점적이고 양도 불가능한 권한을 부여하여 본 소프트웨어를 설치하고 사용할 수 있습니다.")

                            Text("## 2. 사용 제한")
                            Text("귀하는 다음과 같은 행위를 해서는 안 됩니다:")
                            Text("- 소프트웨어의 소스 코드를 수정, 재배포 또는 재판매하는 행위")
                            Text("- 소프트웨어를 불법적인 목적으로 사용하는 행위")
                            Text("- 소프트웨어를 허가되지 않은 방식으로 사용하는 행위")
                            Text("- 불쾌감을 주는 콘텐츠를 생성하거나 배포하는 행위")
                            Text("- 학대적이거나 폭력적인 행동을 조장하거나 묘사하는 행위")
                            Text("- 타인을 괴롭히거나 차별하는 행위")

                            Text("## 3. 소프트웨어 소유권")
                            Text("본 소프트웨어 및 그 모든 권리, 소유권 및 지적 재산권은 회사에 속합니다. 귀하는 소프트웨어의 소유권을 주장할 수 없습니다.")

                            Text("## 4. 면책 조항")
                            Text("회사는 소프트웨어의 사용으로 인해 발생하는 직접적, 간접적, 우발적, 특별 또는 결과적 손해에 대해 책임지지 않습니다. 소프트웨어는 \"있는 그대로\" 제공됩니다.")

                            Text("## 5. 불쾌감을 주는 콘텐츠에 대한 정책")
                            Text("회사는 불쾌감을 주는 콘텐츠나 학대적인 사용자에 대해 제로 톨러런스(Zero Tolerance) 정책을 시행합니다. 귀하는 소프트웨어를 사용함으로써 이러한 정책을 준수할 것에 동의합니다. 위반 시 귀하의 계정이 정지되거나 영구적으로 삭제될 수 있습니다.")

                            Text("## 6. 개인정보 보호")
                            Text("회사는 귀하의 개인 정보를 보호하기 위해 최선을 다하며, 귀하의 정보를 수집하고 사용하는 방식에 대한 자세한 내용은 [개인정보 보호 정책 링크]를 참조하십시오.")

                            Text("## 7. 약관의 수정")
                            Text("회사는 본 계약의 내용을 수시로 수정할 수 있으며, 변경된 약관은 소프트웨어 내에 공지됩니다.")

                            Text("## 8. 법적 준거")
                            Text("본 계약은 [관할 지역]의 법률에 따라 해석되고 집행됩니다.")

                            Text("## 9. 동의")
                            Text("귀하는 본 계약의 모든 조건에 동의하며, 본 소프트웨어를 설치하거나 사용함으로써 이 계약을 수락합니다.")

                        }
                        .padding()
                    }

            HStack {
                Button("동의하기") {
                    // 동의 후 프로세스 진행
                    isPresented = false
                    UserDefaults.standard.set(true, forKey: "약관_동의")
                }
                .padding()

                Button("취소") {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend)) // 홈 화면으로 이동
                }
                .padding()
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.7)
        .background(Color.white)
        .cornerRadius(15)
    }

}




//#Preview {
//    LoginPage()
//}


