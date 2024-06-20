//
//  ImageViewer.swift
//  Infixel
//
//  Created by 차상진 on 6/13/24.
//

import SwiftUI



struct ImageViewer: View {
    let imageUrl: String

    var body: some View {
        //VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                        .background(Color.black)
                        .edgesIgnoringSafeArea(.all)
                case .failure:
                    Image(systemName: "photo")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        //}
    }
}

#Preview {
    ImageViewer(imageUrl: "http://localhost:3000/image/randomjpg")
}
