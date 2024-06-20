//
//  SignInView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/21.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var userEmail                :String = ""
    @State var userPW                   :String = ""
    @State var confirmPW                :String = ""
    @State var userName                 :String = ""
    @State var userId                   :String = ""
    
    //placeHolder
    @State var placeHolder_email        :String = "E-Mail"
    @State var placeHolder_pw           :String = "Password"
    @State var placeHolder_confirm_pw   :String = "Confirm Password"
    @State var placeHolder_name         :String = "Nick Name"
    @State var placeHolder_id           :String = "@"
    
    //알림 메시지
    @State var alertMessage             :String = "재입력 해주세요."
    
    //secure
    @State var secure                   :Bool   = true
    @State var notSecure                :Bool   = false
    
    //알림 변수
    @State var showAlert                :Bool   = false
    @State var emptyInputAlert          :Bool   = false
    @State var passwordAlert            :Bool   = false
    
    //
    @State var isSignup                 :Bool   = false
    
    
    
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
                    .padding(.top, 30)
                    
                InputView(inputValue: $userPW, placeHolder: $placeHolder_pw, secure: $secure)
                    .padding(.bottom, 10)
                    
                InputView(inputValue: $confirmPW, placeHolder: $placeHolder_confirm_pw, secure: $secure)
                    .padding(.bottom, 10)
                
                InputView(inputValue: $userName, placeHolder: $placeHolder_name, secure: $notSecure)
                    .padding(.bottom, 10)
                
                InputView(inputValue: $userId, placeHolder: $placeHolder_id, secure: $notSecure)
                    

                Button {
                    
                    //모든 값이 비어있을때
                    if userEmail == "" || userPW == "" || userName == "" || userId == "" {
                        alertMessage = "값을 입력해주세요."
                        print(alertMessage)
                        showAlert = true
                    
                    //비밀번호가 다를때
                    } else if userPW != confirmPW  {
                        alertMessage = "비밀번호가 다릅니다."
                        print(alertMessage)
                        showAlert = true
                    } else if !isValidEmail(userEmail) {
                        alertMessage = "이메일 형식이 아닙니다."
                        showAlert = true
                    }
                    
                    else {
                        sendTextToServer()
                        print(isSignup)
                        if isSignup {
                            
                            showAlert = false
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            alertMessage = "재시도 해주세요."
                            showAlert = true
                        }
                    }

                } label: {
                    Text("sign up")
                     .font(Font.custom("Bungee-Regular", size: 18))
                     .foregroundColor(Color(UIColor(hexCode: "202FB4")))
                     .padding(.leading, 60)
                     .padding(.trailing, 60)
                     .padding(13)
                     .background(Color(UIColor(hexCode: "ABB2F2")))
                     .cornerRadius(30)
                     .padding(.top, 50)
                     .padding(.bottom, 50)
                }//label
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("회원가입 실패"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인"))
                    )//Alert
                }//alert
            
            }//VStack
                    
        }//ZStack
        
    }//body
    
    
    func sendTextToServer() {
        let userDict: [String: Any] = ["userEmail": self.userEmail, "userPW": self.userPW, "confirmPW": self.confirmPW , "userName": self.userName, "userId": self.userId]
        
              
                           do {
                           
                           //유저가 입력한 값들을 변수에 할당하여 json으로 바꾼 데이터를 jsonData에 할당
                           let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: [])
                           
                           //if jsonString에 값이 할당이 되면 동작
                           if let jsonString = String(data: jsonData, encoding: .utf8) {
                               print("JSON: \(jsonString)")
                           }//if
                           
                           guard let url = URL(string: VarCollectionFile.signupURL) else {
                               print("Invalid URL")
                               return
                           }//guard
                           
                           //요청 객체 생성
                           var request = URLRequest(url: url)
                           request.httpMethod = "POST"
                           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                           request.httpBody = jsonData
                           
                           
                           URLSession.shared.dataTask(with: request) { data, response, error in
                               
                               //요청을 전송할때 에러가 나면
                               if let error = error {
                                   print("Error sending data: \(error)")
                               }
                               
                               //data에 가져와진 데이터가 할당이 되면
                               else if let data = data {
                                   if let responseString = String(data: data, encoding: .utf8) {
                                       if let data = responseString.data(using: .utf8),
                                          let resultValue = try? JSONDecoder().decode(Bool.self, from: data) {
                                           isSignup = resultValue
                                           
//                                           if isSignup {
//                                               showAlert = false
//                                           } else {
//                                               alertMessage = "재시도 해주세요."
//                                               showAlert = true
//                                           }
                                      } else {
                                          print("Error decoding JSON")
                                      }
                                   }
                               }
                           }.resume() //URLSession
                       } catch {
                           print("Error encoding JSON: \(error.localizedDescription)")
                       }
                           
                        
                   
                   
                   
              
        }//sendTextToServer
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





//#Preview {
//    SignUpView()
//}
