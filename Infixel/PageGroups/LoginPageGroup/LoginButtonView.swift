//
//  LoginButtonView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI

struct LoginButtonView: View {
    
    @Binding var isLoggedIn: Bool

    @Binding var userId : String
    @Binding var userPW : String
    @State var showAlert = false
    
    
    var body: some View {
        Button(action: {
                        print("로그인 버튼 뷰")
                        print("ID : ", userId)
                        print("PW : ", userPW)
            
                        sendTextToServer()
//            if userId == "test" && userPW == "test" {
//                isLoggedIn = true
//            }
            
                       
                    }) {
                        Text("Login")
                            //.font(.system(size: 18, weight: .bold))
                            .font(Font.custom("Bungee-Regular", size: 18))
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
    
    func sendTextToServer() {
       
        let userDict: [String: Any] = ["userId": self.userId, "userPW": self.userPW]
               
               do {
                
                   let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: [])
                                if let jsonString = String(data: jsonData, encoding: .utf8) {
                                    print("JSON: \(jsonString)")
                                }
                   
                   guard let url = URL(string: VarCollectionFile.loginURL) else {
                           print("Invalid URL")
                           return
                       }
                   
                   
                   var request = URLRequest(url: url)
                                   request.httpMethod = "POST"
                                   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                   request.httpBody = jsonData
                   
                   URLSession.shared.dataTask(with: request) { data, response, error in
                                       if let error = error {
                                           print("Error sending data: \(error)")
                                       } else if let data = data {
                                           if let responseString = String(data: data, encoding: .utf8) {
                                               print("Server response: \(responseString)")
                                               if let data = responseString.data(using: .utf8),
                                                         let resultValue = try? JSONDecoder().decode(Bool.self, from: data) {
                                                          isLoggedIn = resultValue
                                                   print(isLoggedIn)
                                                      } else {
                                                          print("Error decoding JSON")
                                                      }
                                           }
                                       }
                                   }.resume()
                   
                   
                   
               } catch {
                   print("Error encoding JSON: \(error.localizedDescription)")
               }
        }//sendTextToServer
    
    
}

struct ServerResponse: Codable {
    let success: Bool
}

//
//struct LoginButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginButtonView()
//    }
//}
