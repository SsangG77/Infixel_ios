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
        Button {
            sendTextToServer()
        } label: {
            Text("Login")
             .font(Font.custom("Bungee-Regular", size: 18))
             .foregroundColor(Color(UIColor(hexCode: "202FB4")))
             .padding(.leading, 60)
             .padding(.trailing, 60)
             .padding(13)
             .background(Color(UIColor(hexCode: "ABB2F2")))
             .cornerRadius(30)
        }//label
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("로그인 실패"),
                message: Text("ID, Password를 확인하세요."),
                dismissButton: .default(Text("확인"))
            )//Alert
        }//alert
    }//body
    
    func sendTextToServer() {
        let userDict: [String: Any] = ["userId": self.userId, "userPW": self.userPW]
               do {
                   let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: [])
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print("JSON: \(jsonString)")
                   }//if
                   guard let url = URL(string: VarCollectionFile.loginURL) else {
                       print("Invalid URL")
                       return
                   }//guard
                   
                   var request = URLRequest(url: url)
                   request.httpMethod = "POST"
                   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                   request.httpBody = jsonData
                   
                   URLSession.shared.dataTask(with: request) { data, response, error in
                       if let error = error {
                           print("Error sending data: \(error)")
                       } else if let data = data {
                           if let responseString = String(data: data, encoding: .utf8) {
                               print(responseString)
                               do {
                                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                       if let id            = json["id"]            as? String,
                                          let user_at       = json["user_at"]       as? String,
                                          let user_name     = json["user_name"]     as? String,
                                          let created_at    = json["created_at"]    as? String,
                                          let profile_image = json["profile_image"] as? String,
                                          let description   = json["description"]   as? String,
                                          let isLogin       = json["isLogin"]       as? Bool {
                                           print("id : \(id)")
                                           print("is login : \(isLogin)")
                                           isLoggedIn = isLogin
                                           if isLoggedIn { //로그인 성공
                                               // 데이터 저장
                                               UserDefaults.standard.set(id, forKey: "user_id")
                                               UserDefaults.standard.set(user_at, forKey: "user_at")
                                               UserDefaults.standard.set(user_name, forKey: "user_name")
                                               UserDefaults.standard.set(created_at, forKey: "created_at")
                                               UserDefaults.standard.set(profile_image, forKey: "profile_image")
                                               UserDefaults.standard.set(description, forKey: "description")
                                               
                                               showAlert = false
                                           } else { //로그인 실패
                                                showAlert = true
                                           }
                                           
                                       }
                                   }
                               } catch {
                                   print("error : \(error)")
                               }
                               
//                               if let data = responseString.data(using: .utf8),
//                                  let resultValue = try? JSONDecoder().decode(Bool.self, from: data) {
//                                   isLoggedIn = resultValue
//                                   print(isLoggedIn)
//                                   if isLoggedIn {
//                                       showAlert = false
//                                   } else {
//                                       showAlert = true
//                                   }
//                              } else {
//                                  print("Error decoding JSON")
//                              }
                           }
                       }
                   }.resume() //URLSession
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
