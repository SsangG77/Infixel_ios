//
//  ThreeDotsView.swift
//  Infixel
//
//  Created by 차상진 on 7/15/24.
//

import SwiftUI


//info button view에서 점세개 버튼을 눌렀을때 나타나는 뷰
struct ThreeDotsView: View {
    
    @ObservedObject var viewModel = ThreeDotsViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                Rectangle() //상단 핸들 모양
                    .frame(width: 40.0, height: 10)
                    .foregroundColor(Color(hexString: "F4F2F2"))
                    .cornerRadius(20)
                    .padding([.top, .bottom], 20)
                    
            }//VStack
            .frame(width: UIScreen.main.bounds.width, height: 50)
            .background(.white)
            
            VStack {
                
                HStack {
                    Text("이미지 다운로드")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom, 7)
                
                HStack {
                    
                    Text("이미지 신고")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                    
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.3)
            .padding(.top, 10)
            .background(.white)
        }
        .cornerRadius(20)
        .gesture(
            DragGesture()
           .onChanged { value in
               if appState.imageViewerOrNot {
                   
               } else {
                   appState.threeDotsOffset = value.translation.height + UIScreen.main.bounds.height * 0.7
               }
               
           }
            .onEnded { value in
                if appState.imageViewerOrNot {
                    
                }
            }
       )
    }
}

class ThreeDotsViewModel: ObservableObject {
    
}

#Preview {
    ZStack {
        Color(.black).edgesIgnoringSafeArea(.all)
        ThreeDotsView()
    }
    
}
