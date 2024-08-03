//
//  NavigationChildView_test.swift
//  Infixel
//
//  Created by 차상진 on 8/4/24.
//

import SwiftUI

struct NavigationChildView_test: View {
    @State private var isActive: Bool = false

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
                .navigationTitle("Parent View")
            }
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
    var body: some View {
        Text("sssssssss")
    }
}

#Preview {
    NavigationChildView_test()
}
