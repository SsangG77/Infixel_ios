//
//  ImageGridView.swift
//  Infixel
//
//  Created by 차상진 on 7/7/24.
//

import SwiftUI


struct ImageGridItemView: View {
    var imageURL: String
    let onTap: () -> Void
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 150)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onTapGesture {
                        onTap()
                    }
            case .failure(let error):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            @unknown default:
                EmptyView()
            }
        }
    }
}






struct ImageGridView: View {
    @Binding var images: [SearchSingleImage]
    var onTap: (String, String) -> Void = { _, _ in }
    
    
    var body: some View {
            HStack(alignment: .top, spacing: 10) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<((images.count + 1) / 2), id: \.self) { index in
                        if index * 2 < images.count {
                            ImageGridItemView(
                                imageURL: images[index * 2].image_name,
                                onTap: {
                                    onTap(images[index * 2].id, images[index * 2].image_name)
                                }
                            )
                        }
                    }
                }
                
                LazyVStack(spacing: 10) {
                    ForEach(0..<((images.count + 1) / 2), id: \.self) { index in
                        if index * 2 + 1 < images.count {
                            ImageGridItemView(
                                imageURL: images[index * 2 + 1].image_name,
                                onTap: {
                                    onTap(images[index * 2 + 1].id, images[index * 2 + 1].image_name)
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
}

#Preview {
    ImageGridView(images: .constant([
        SearchSingleImage(id: "1", image_name: VarCollectionFile.resjpgURL + "winter2.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "haewon3.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon.webp"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "winter4.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "winter5.jpeg"),
        SearchSingleImage(id: "2", image_name: VarCollectionFile.resjpgURL + "chaewon1.jpeg"),
    ])
    )
}
