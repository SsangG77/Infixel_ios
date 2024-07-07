import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SignUpViewModel()
    
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
        ZStack {
            ImageGridView(images: $images)
                .blur(radius: 15)
            
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color(hexString: "898989")
                            .opacity(0.7))
                    .frame(height: geometry.size.height * 2)
                    .offset(y: -100)
            }
            
            VStack {
                Text("Sign up")
                    .font(Font.custom("Bungee-Regular", size: 50))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                
//                InputView(inputValue: $viewModel.userEmail, placeHolder: .constant("E-Mail"), secure: .constant(false))
//                    .padding(.bottom, 10)
//                    .padding(.top, 30)
//                
//                InputView(inputValue: $viewModel.userPW, placeHolder: .constant("Password"), secure: .constant(true))
//                    .padding(.bottom, 10)
//                
//                InputView(inputValue: $viewModel.confirmPW, placeHolder: .constant("Confirm Password"), secure: .constant(true))
//                    .padding(.bottom, 10)
//                
//                InputView(inputValue: $viewModel.userName, placeHolder: .constant("Nick Name"), secure: .constant(false))
//                    .padding(.bottom, 10)
//                
//                InputView(inputValue: $viewModel.userId, placeHolder: .constant("@"), secure: .constant(false))
                
                Button {
                    if viewModel.userEmail.isEmpty || viewModel.userPW.isEmpty || viewModel.userName.isEmpty || viewModel.userId.isEmpty {
                        viewModel.alertMessage = "값을 입력해주세요."
                        print(viewModel.alertMessage)
                        viewModel.showAlert = true
                    } else if viewModel.userPW != viewModel.confirmPW {
                        viewModel.alertMessage = "비밀번호가 다릅니다."
                        print(viewModel.alertMessage)
                        viewModel.showAlert = true
                    } else if !viewModel.isValidEmail(viewModel.userEmail) {
                        viewModel.alertMessage = "이메일 형식이 아닙니다."
                        viewModel.showAlert = true
                    } else {
                        viewModel.sendTextToServer()
                        if viewModel.isSignup {
                            viewModel.showAlert = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.alertMessage = "재시도 해주세요."
                            viewModel.showAlert = true
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
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("회원가입 실패"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
        }
    }
}


struct SignUpInputView: View {
    
    var body: some View {
        HStack {
            
        }
    }
}



#Preview {
    SignUpView()
}
