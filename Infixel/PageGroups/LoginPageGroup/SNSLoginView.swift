//
//  SNSLoginView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI
import Combine
import KakaoSDKAuth
import KakaoSDKUser

struct SNSLoginView: View {
    
    @StateObject var snsLoginViewModel = SNSLoginViewModel()
    
    @Binding var isLoggedIn: Bool
    
    
    var body: some View {
        HStack {
            
            let size = 45.0
            
            Image("kakao_login_medium_wide")
                .resizable()
                .frame(width: 220, height: 35)
                .cornerRadius(10)
                .onTapGesture {
                    VarCollectionFile.myPrint(title: "카카오 로그인", content: "클릭됨")
                    snsLoginViewModel.kakaoLogin($isLoggedIn)
                }
            
//            Image("kakao_icon")
//                .resizable()
//                .frame(width: size, height: size)
//                .cornerRadius(35)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 35)
//                        .stroke(.black, lineWidth: 2)
//                )
//                .onTapGesture {
//                    print("카카오 로그인")
//                    snsLoginViewModel.kakaoLogin()
//                }
            
            
//            Image("google_icon")
//                .resizable()
//                .frame(width: size, height: size)
//                .cornerRadius(35)
//                .overlay(
//                       RoundedRectangle(cornerRadius: 35)
//                           .stroke(.black, lineWidth: 2)
//                   )
//                .onTapGesture {
//                    print("구글 로그인")
//                }
//                .padding(.leading, 10)
//                .padding(.trailing, 10)
            
            
            //insta
//            Image("Instagram_Glyph_Icon")
//                .resizable()
//                .frame(width: size, height: size)
//                .cornerRadius(35)
//                .overlay(
//                       RoundedRectangle(cornerRadius: 35)
//                           .stroke(.black, lineWidth: 2)
//                   )
//                .onTapGesture {
//                    print("인스타 로그인")
//                }
            
        }
    }
}


class SNSLoginViewModel: ObservableObject {
    
    
    func kakaoLogin(_ isLoggedIn: Binding<Bool>) {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) { //카카오톡 설치 유무 확인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

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
                    print("loginWithKakaoAccount() success.")

                    // 성공 시 동작 구현
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            
                            if let nickname = user?.kakaoAccount?.profile?.nickname, let id = user?.id {
                                VarCollectionFile.myPrint(title: "카카오 로그인 성공 유저 정보", content: "닉네임 : \(nickname) \nid : \(id)")
                                
                                self.sendKakaoInfo(nickName: nickname, id: String(id), isLoggedIn)
                                
                                
                            } else {
                                print("User nickname not found.")
                            }
                            
                        }
                    }
                }
            }
        }
    } //kakaoLogin
    
    func sendKakaoInfo(nickName: String, id: String, _ isLoggedIn: Binding<Bool>) {
        
        struct kakaoResponse: Codable, Identifiable, Hashable {
            var id: String
            var user_at: String
            var user_name: String
            var created_at: String
            var profile_image: String
            var description: String
            var isLogin: Bool
        }
        
        let deviceToken = UserDefaults.standard.string(forKey: "device_token") ?? ""
        
        let userDict: [String: String] = [
            "nick_name" : nickName,
            "kakao_id" : id,
            "device_token" : deviceToken
        ]
        
        guard let url = URL(string: VarCollectionFile.kakaoLoginURL) else {
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
                    print("Received raw JSON: \(jsonString)")
                }
            
            do {
                let decodeResponse = try JSONDecoder().decode(kakaoResponse.self, from: data)
                print("서버 응답: \(decodeResponse)") // 서버 응답 로그 출력
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


    
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    } //kakaoLogout
    
    
    
    
    
}


//struct SNSLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        SNSLoginView()
//    }
//}
