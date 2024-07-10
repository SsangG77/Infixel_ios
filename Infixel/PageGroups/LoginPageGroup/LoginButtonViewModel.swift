//
//  LoginButtonViewModel.swift
//  Infixel
//
//  Created by 차상진 on 7/7/24.
//

import Foundation
import Combine
import SwiftUI


class LoginButtonViewModel: ObservableObject {
    
    
    @Published var userId: String = ""
    @Published var userPW: String = ""
    @Published var showAlert: Bool = false
    
    
    
    func sendTextToServer(_ isLoggedIn: Binding<Bool>) {
        let userDict: [String: Any] = ["userId": userId, "userPW": userPW]
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
            
            URLSession.shared.dataTask(with: request) {data, response, error in
                //guard let self = self else { return }
                if let error = error {
                    print("Error sending data: \(error)")
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
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
                                    DispatchQueue.main.async {
                                        isLoggedIn.wrappedValue = isLogin
                                        if isLoggedIn.wrappedValue { // 로그인 성공

                                            // 데이터 저장
                                            UserDefaults.standard.set(id, forKey: "user_id")
                                            UserDefaults.standard.set(user_at, forKey: "user_at")
                                            UserDefaults.standard.set(user_name, forKey: "user_name")
                                            UserDefaults.standard.set(created_at, forKey: "created_at")
                                            UserDefaults.standard.set(profile_image, forKey: "profile_image")
                                            UserDefaults.standard.set(description, forKey: "description")
                                            
                                            
                                            self.showAlert = false
                                        } else { // 로그인 실패
                                            self.showAlert = true
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("error : \(error)")
                        }
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
        }
    }

    
}
