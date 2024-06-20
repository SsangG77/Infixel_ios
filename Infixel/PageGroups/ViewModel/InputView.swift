//
//  InputView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/21.
//

import SwiftUI

struct InputView: View {
    
    //프리뷰용 변수
    //@State var inputValue:String = ""
    //@State var placeHolder:String = "test"
    
    //
    @Binding var inputValue:String
    @Binding var placeHolder:String
    @Binding var secure:Bool
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 30)
                VStack {
                    ZStack(alignment: .leading) {
                        if inputValue.isEmpty {
                            Text(placeHolder)
                            .bold()
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding()
                            .padding(.leading, 10)
                            .underline(true, color: .white.opacity(0.6))
                            .font(Font.custom("Bungee-Regular", size: 20))
                        } //if
                        if secure {
                            SecureField("", text: $inputValue)
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding()
                                .padding(.leading, 10)
                                .frame(height: 60)
                        }//if
                        else {
                            TextField("", text: $inputValue)
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding()
                                .padding(.leading, 10)
                                .frame(height: 60)
                        }//else
                    }//ZStack
                }//VStack
                .overlay(
                       RoundedRectangle(cornerRadius: 25)
                           .stroke(.white, lineWidth: 5)
                   )
                .background(.black)
                .cornerRadius(25)
                Spacer().frame(width: 30)
            }//HStack
        }//VStack
    }
}

//#Preview {
//    
//    @State var inputValue:String = ""
//    @State var placeHolder:String = "test"
//    
//    InputView(inputValue: $inputValue, placeHolder: $placeHolder)
//}
