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
    
    var body: some View {
        HStack {
            
            let size = 45.0
            
            Image("kakao_icon")
                .resizable()
                .frame(width: size, height: size)
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(.black, lineWidth: 2)
                )
                .onTapGesture {
                    print("카카오 로그인")
                    snsLoginViewModel.kakaoLogin()
                }
            
            
            Image("google_icon")
                .resizable()
                .frame(width: size, height: size)
                .cornerRadius(35)
                .overlay(
                       RoundedRectangle(cornerRadius: 35)
                           .stroke(.black, lineWidth: 2)
                   )
                .onTapGesture {
                    print("구글 로그인")
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            
            //insta
            Image("Instagram_Glyph_Icon")
                .resizable()
                .frame(width: size, height: size)
                .cornerRadius(35)
                .overlay(
                       RoundedRectangle(cornerRadius: 35)
                           .stroke(.black, lineWidth: 2)
                   )
                .onTapGesture {
                    print("인스타 로그인")
                }
            
        }
    }
}


class SNSLoginViewModel: ObservableObject {
    
    
    func kakaoLogin() {
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
                            
                            if let nickname = user?.kakaoAccount?.profile?.nickname {
                                VarCollectionFile.myPrint(title: "카카오 로그인 성공 유저 정보", content: nickname)
                                                } else {
                                                    print("User nickname not found.")
                                                }
                            
                        }
                    }
                }
            }
        }
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
    }
    
    
    
}


struct SNSLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SNSLoginView()
    }
}
