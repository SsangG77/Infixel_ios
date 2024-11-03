//
//  SNSLoginView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI
//import Combine
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

struct SNSLoginView: View {
    
    @StateObject var snsLoginViewModel = SNSLoginViewModel()
    
    @Binding var isLoggedIn: Bool
    
    
    var body: some View {
        HStack {
            
            let size = 45.0
            
            VStack {
                
                Image("kakao_login_medium_wide")
                    .resizable()
                    .frame(width: 220, height: 35)
                    .cornerRadius(10)
                    .onTapGesture {
                        snsLoginViewModel.kakaoLogin($isLoggedIn)
                    }
                
                AppleSigninButton(isLoggedIn: $isLoggedIn)
            }
            
            
            
        }
    }
}

//--@-------------------------------------------------------------------------------------------------------------------------


struct AppleSigninButton : View {
    
    @Binding var isLoggedIn: Bool
    
    let viewModel = SNSLoginViewModel()
    
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential{
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                           // 계정 정보 가져오기
                            let UserIdentifier = appleIDCredential.user
                            let fullName = appleIDCredential.fullName
                            let name =  (fullName?.familyName ?? "성 없음") + (fullName?.givenName ?? " 이름 없음")
                            let email = appleIDCredential.email
                            let IdentityToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
                            let AuthorizationCode = appleIDCredential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }

                        
                        VarCollectionFile.myPrint(title: "로그인된 애플 아이디", content:
                              "* - user identifier : \(UserIdentifier)\n"
                              + "* - name : \(String(name))\n"
                        )
                        
                        viewModel.sendInfo(type: "apple", nickName: name, id: UserIdentifier, $isLoggedIn)
                        
                        
                        
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        )
        .frame(width: 220, height: 35)
        .cornerRadius(10)
    }
}

//--@-------------------------------------------------------------------------------------------------------------------------

class SNSLoginViewModel: ObservableObject {
    
    struct snsResponse: Codable, Identifiable, Hashable {
        var id: String
        var user_at: String
        var user_name: String
        var created_at: String
        var profile_image: String
        var description: String
        var isLogin: Bool
    }
    
    func kakaoLogin(_ isLoggedIn: Binding<Bool>) {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) { //카카오톡 설치 유무 확인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {

                    // 성공 시 동작 구현
                    _ = oauthToken
                }
            }
        } else {
            //웹 브라우저에서 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {

                    // 성공 시 동작 구현
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            
                            if let nickname = user?.kakaoAccount?.profile?.nickname, let id = user?.id {
                                
                                self.sendInfo(type: "kakao", nickName: nickname, id: String(id), isLoggedIn)
                                
                                
                            } else {
                                print("User nickname not found.")
                            }
                            
                        }
                    }
                }
            }
        }
    } //kakaoLogin
    
    func sendInfo(type: String, nickName: String, id: String, _ isLoggedIn: Binding<Bool>) {
        
//        let type = "kakao"
        
        
        let deviceToken = UserDefaults.standard.string(forKey: "device_token") ?? ""
        
        var url = ""
        var userDict: [String: String] = [:]
        
        if type == "kakao" {
            url = VarCollectionFile.kakaoLoginURL
            userDict = [
                "nick_name" : nickName,
                "kakao_id" : id,
                "device_token" : deviceToken
            ]
            
        } else if type == "apple" {
            url = VarCollectionFile.appleLoginURL
            userDict = [
                "nick_name" : nickName,
                "user_id" : id,
                "device_token" : deviceToken
            ]
        }
        
        
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userDict) else {
            print("Error encoding JSON")
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending data: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Received raw JSON: \(jsonString)")
                }
            
            do {
                let decodeResponse = try JSONDecoder().decode(snsResponse.self, from: data)
                //print("서버 응답: \(decodeResponse)") // 서버 응답 로그 출력
                VarCollectionFile.myPrint(title: "서버 응답 로그 출력", content: decodeResponse)
                DispatchQueue.main.async {
                    if decodeResponse.isLogin {
                        isLoggedIn.wrappedValue = true
                        UserDefaults.standard.set(decodeResponse.id, forKey: "user_id")
                        UserDefaults.standard.set(decodeResponse.user_at, forKey: "user_at")
                        UserDefaults.standard.set(decodeResponse.user_name, forKey: "user_name")
                        UserDefaults.standard.set(decodeResponse.created_at, forKey: "created_at")
                        UserDefaults.standard.set(decodeResponse.profile_image, forKey: "profile_image")
                        UserDefaults.standard.set(decodeResponse.description, forKey: "description")
                    } else {
                        isLoggedIn.wrappedValue = false
                    }
                }
            } catch {
                print("Decoding failed: \(error.localizedDescription)")
            }
            
        }.resume()

    }


    func disableUser() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")!
        
        let json: [String:Any] = [
            "user_id" : user_id
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            
            guard let url = URL(string: VarCollectionFile.userDisableURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error sending data: \(error)")
                } else if let data = data {
                    print(data)
                }
            }.resume()
            
        } catch {
            print("Error")
        }
        
        
        
    }
    
    
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            
        }
    } //kakaoLogout
    
} //SNSLoginViewModel


//struct SNSLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        SNSLoginView()
//    }
//}
