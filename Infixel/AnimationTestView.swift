//
//  AnimationTestView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/26.
//

import SwiftUI

struct AnimationTestView: View {
    @State private var isAnimating = false
    @State private var animationFinished = false

        var body: some View {
            Text("Hello, Animation!")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scaleEffect(isAnimating ? 2 : 1)
                .onTapGesture {
                    if #available(iOS 17.0, *) {
                        withAnimation(.linear(duration: 1), {
                            isAnimating.toggle()
                        }) {
                            // 애니메이션 완료를 감지하고 "애니메이션 종료" 메시지를 출력합니다.
                            print("애니메이션 종료")
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                            }
        }
}

#Preview {
    AnimationTestView()
}
