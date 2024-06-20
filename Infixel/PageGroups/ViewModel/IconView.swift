//
//  IconView.swift
//  Infixel
//
//  Created by 차상진 on 10/31/23.
//

import SwiftUI

struct IconView: View {
    var imageName: String
    var size: CGFloat
    var padding: EdgeInsets
    var action: () -> Void
    

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: size, height: size)
            .padding(padding)
            .onTapGesture(perform: action)
    }
}

//#Preview {
//    IconView()
//}
