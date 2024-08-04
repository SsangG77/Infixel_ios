//
//  NavigationChildView_test.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI

struct NavigationChildView_test: View {
    @State private var isActive: Bool = false
    
    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white] // 뒤로가기 버튼 텍스트 색 설정
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        var body: some View {
            NavigationView {
                VStack {
                    ChildView(isActive: $isActive)
                    NavigationLink(
                        destination: NextView(),
                        isActive: $isActive,
                        label: {
                            EmptyView() // Label을 빈 뷰로 설정하여 숨김
                        }
                    )
                }
//                .navigationTitle("Parent View")
            }
            .accentColor(.white)
            
        }
}

struct ChildView: View {
    @Binding var isActive: Bool

    var body: some View {
        Button(action: {
            isActive = true
        }) {
            Text("Navigate to Next View")
        }
    }
}


struct NextView: View {
    
//    @Binding var userId:String
    
    var body: some View {
        Text("user id :")
    }
}

#Preview {
    NavigationChildView_test()
}
