//
//  AsyncImageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.



import SwiftUI

struct AsyncImageView: View {
    
    //@Binding var imageURL: URL?
    @Binding var imageURL : String
    
    var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.width
            //let imageHeight = geometry.size.height
            
            AsyncImage(url: URL(string :imageURL)) { phase in
                switch phase {
                case .empty:
                    Spacer()
                    ProgressView() // 이미지를 로드 중일 때 표시할 로딩 화면
                    Spacer()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                       
                case .failure:
                    // 이미지 로드 실패 시 메시지
                    // Image("loading")
                    ProgressView()
                @unknown default:
                    Text("Unknown state") // 알 수 없는 상태 처리
                }
            }
            .frame(width: imageWidth)
        }
        //.clipped()
    }
}

