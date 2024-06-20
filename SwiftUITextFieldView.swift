//
//  SwiftUITextFieldView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/16.
//

import SwiftUI

struct TextFieldExample: View {
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var type: String = ""
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    if title.isEmpty {
                        Text("Course title")
                        .bold()
                        .foregroundColor(Color.white.opacity(0.6))
                        
                    }
                    TextField("", text: $title)
                        .foregroundColor(.white.opacity(0.6))
                
                }
              
                .background(.black)
                
            }
            .padding(.top, 20) }.padding()
        
    }
    
}

struct SwiftUITextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldExample()
    }
}
