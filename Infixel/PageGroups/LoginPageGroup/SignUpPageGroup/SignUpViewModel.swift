//
//  SignUpViewModel.swift
//  Infixel
//
//  Created by 차상진 on 7/7/24.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    @Published var userEmail: String = ""
    @Published var userPW: String = ""
    @Published var confirmPW: String = ""
    @Published var userName: String = ""
    @Published var userId: String = ""
    
    @Published var alertMessage: String = "재입력 해주세요."
    @Published var showAlert: Bool = false
    @Published var isSignup: Bool = false
    
    
    
    
    func sendTextToServer() {
        
        
        let userDict: [String: Any] = [
            "userEmail": self.userEmail,
            "userPW": self.userPW,
            "confirmPW": self.confirmPW,
            "userName": self.userName,
            "userId": self.userId,
            "deviceToken": UserDefaults.standard.string(forKey: "device_token")
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: [])
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("SignUpViewModel - JSON: \(jsonString)")
            }
            
            guard let url = URL(string: VarCollectionFile.signupURL) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error sending data: \(error)")
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        if let data = responseString.data(using: .utf8),
                           let resultValue = try? JSONDecoder().decode(Bool.self, from: data) {
                            DispatchQueue.main.async {
                                self.isSignup = resultValue
                                self.showAlert = !resultValue
                                self.alertMessage = resultValue ? "" : "재시도 해주세요."
                            }
                        } else {
                            print("Error decoding JSON")
                        }
                    }
                }
            }.resume()
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
        }
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        if let regex = try? NSRegularExpression(pattern: emailPattern) {
            let range = NSRange(location: 0, length: email.utf16.count)
            let matches = regex.numberOfMatches(in: email, options: [], range: range)
            return matches > 0
        }
        return false
    }
}
