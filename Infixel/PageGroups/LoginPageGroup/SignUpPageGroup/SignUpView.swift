import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var signupViewModel = SignUpViewModel()
    @ObservedObject var loginViewModel = LoginButtonViewModel()
    
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
    
    @State private var showTermsPopup = false
    
    var body: some View {
        ZStack {
            ImageGridView(images: $images)
                .blur(radius: 15)
            
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color(hexString: "898989")
                            .opacity(0.7))
                    .frame(height: geometry.size.height * 2)
                    .offset(y: -100)
            }//geo
            
            VStack {
                Text("Sign up")
                    .font(Font.custom("Bungee-Regular", size: 50))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                
                InputView(inputValue: $signupViewModel.userEmail, placeHolder: .constant("E-Mail"), secure: .constant(false), loginViewModel: loginViewModel, signupViewModel: signupViewModel) {
                    loginViewModel, signupViewModel_ in
                    signupViewModel_.userEmail = signupViewModel.userEmail
                }
                .padding(.bottom, 10)
                .padding(.top, 30)
                
                InputView(inputValue: $signupViewModel.userPW, placeHolder: .constant("Password"), secure: .constant(true), loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel_ in
                    signupViewModel_.userPW = signupViewModel.userPW
                }
                .padding(.bottom, 10)
                
                InputView(inputValue: $signupViewModel.confirmPW, placeHolder: .constant("Confirm Password"), secure: .constant(true), loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel_ in
                    signupViewModel_.confirmPW = signupViewModel.confirmPW
                }
                .padding(.bottom, 10)
                
                InputView(inputValue: $signupViewModel.userName, placeHolder: .constant("Nick Name"), secure: .constant(false),loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel_ in
                    signupViewModel_.userName = signupViewModel.userName
                }
                .padding(.bottom, 10)
                
                InputView(inputValue: $signupViewModel.userId, placeHolder: .constant("@"), secure: .constant(false), loginViewModel: loginViewModel, signupViewModel: signupViewModel) { loginViewModel, signupViewModel_ in
                    signupViewModel_.userId = signupViewModel.userId
                }
                
                //========================================================================================================================================================================================================================
           
                
                
                Button {
                    if signupViewModel.userEmail.isEmpty || signupViewModel.userPW.isEmpty || signupViewModel.userName.isEmpty || signupViewModel.userId.isEmpty {
                        signupViewModel.alertMessage = "값을 입력해주세요."
                        signupViewModel.showAlert = true
                    } else if signupViewModel.userPW != signupViewModel.confirmPW {
                        signupViewModel.alertMessage = "비밀번호가 다릅니다."
                        signupViewModel.showAlert = true
                    } else if !signupViewModel.isValidEmail(signupViewModel.userEmail) {
                        signupViewModel.alertMessage = "이메일 형식이 아닙니다."
                        signupViewModel.showAlert = true
                    } else {
                        signupViewModel.sendTextToServer()
                        if signupViewModel.isSignup {
                            signupViewModel.showAlert = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            signupViewModel.alertMessage = "재시도 해주세요."
                            signupViewModel.showAlert = true
                        }
                    }
                } label: {
                    Text("sign up")
                        .font(Font.custom("Bungee-Regular", size: 18))
                        .foregroundColor(Color(hexString: "202FB4"))
                        .padding(.leading, 60)
                        .padding(.trailing, 60)
                        .padding(13)
                        .background(Color(hexString: "ABB2F2"))
                        .cornerRadius(30)
                        .padding(.top, 50)
                        .padding(.bottom, 50)
                }
                .alert(isPresented: $signupViewModel.showAlert) {
                    Alert(
                        title: Text("회원가입 실패"),
                        message: Text(signupViewModel.alertMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }
                
                
                //========================================================================================================================================================================================================================
                
                
            }
        }
    }
}




#Preview {
    SignUpView()
}
