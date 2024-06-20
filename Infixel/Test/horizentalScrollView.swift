//
//  horizentalScrollView.swift
//  Infixel
//
//  Created by 차상진 on 10/31/23.
//

import SwiftUI

struct horizentalScrollView: View {
   
        @State private var slideImageTags = ["Tag1", "Long Tag2", "Very Long Tag3", "Tag4", "Tag5"]

        var body: some View {
            ScrollView(.horizontal) {
                
                HStack {
                    ForEach(slideImageTags, id: \.self) { tag in
     
                        ZStack {
                            Rectangle()
                                .frame(width: CGFloat(tag.count)*10 + 10, height: 30)
                                
                            Text(tag).foregroundColor(.white)
                                
                        }
                    }
                }
            }

        }
}

#Preview {
    horizentalScrollView()
}
