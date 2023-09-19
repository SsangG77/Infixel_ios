//
//  SNSLoginView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/17.
//

import SwiftUI

struct SNSLoginView: View {
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

struct SNSLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SNSLoginView()
    }
}
