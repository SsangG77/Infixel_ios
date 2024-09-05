//
//  ImageGridView.swift
//  Infixel
//
//  Created by 차상진 on 7/7/24.
//

import SwiftUI


struct AsyncImageView2: View {
    @StateObject private var viewModel: ImageLoaderViewModel

    let onTap: () -> Void
    
    init(url: URL, onTap: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ImageLoaderViewModel(url: url))
        self.onTap = onTap
    }
    

    var body: some View {
        Group {
            switch viewModel.phase {
            case .empty:
                ProgressView()
                    .frame(width: 100, height: 100)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .onTapGesture {
                        onTap()
                    }
            case .failure:
                VStack {
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                    Text("Failed to load")
                        .font(.caption)
                }
                .onAppear {
                    viewModel.loadImage()
                }
            }
        }
        .onAppear {
            if case .empty = viewModel.phase {
                viewModel.loadImage()
            }
        }
    }
}

class ImageLoaderViewModel: ObservableObject {
    @Published var phase: AsyncImagePhase = .empty
    private let url: URL
    private var cache = URLCache.shared

    init(url: URL) {
        self.url = url
    }

    func loadImage() {
        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
           let uiImage = UIImage(data: cachedResponse.data) {
            self.phase = .success(Image(uiImage: uiImage))
            return
        }
        
        
        phase = .empty

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    DispatchQueue.main.async {
                        if let data = data, let uiImage = UIImage(data: data), let response = response {
                            let cachedData = CachedURLResponse(response: response, data: data)
                            self.cache.storeCachedResponse(cachedData, for: URLRequest(url: self.url))
                            self.phase = .success(Image(uiImage: uiImage))
                        } else {
                            self.phase = .failure(error)
                        }
                    }
                }
        task.resume()
    }
}

enum AsyncImagePhase {
    case empty
    case success(Image)
    case failure(Error?)
}






//struct ImageGridItemView: View {
//    var imageURL: String
//    let onTap: () -> Void
//    
//    var body: some View {
//        AsyncImage(url: URL(string: imageURL)) { phase in
//            switch phase {
//            case .empty:
//                ProgressView()
//                    .frame(height: 150)
//            case .success(let image):
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                    .onTapGesture {
//                        onTap()
//                    }
//            case .failure(let error):
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 150)
//            @unknown default:
//                EmptyView()
//            }
//        }
//    }
//}






struct ImageGridView: View {
    @Binding var images: [SearchSingleImage]
    var onTap: (String, String) -> Void = { _, _ in }
    
    
    var body: some View {
            HStack(alignment: .top, spacing: 10) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<((images.count + 1) / 2), id: \.self) { index in
                        if index * 2 < images.count {
//                            ImageGridItemView(
//                                imageURL: images[index * 2].image_name,
//                                onTap: {
//                                    onTap(images[index * 2].id, images[index * 2].image_name)
//                                }
//                            )
                            AsyncImageView2(url: URL(string: images[index * 2].image_name)!) {
                                onTap(images[index * 2].id, images[index * 2].image_name)
                           }
                        }
                    }
                }
                
                LazyVStack(spacing: 10) {
                    ForEach(0..<((images.count + 1) / 2), id: \.self) { index in
                        if index * 2 + 1 < images.count {
                            AsyncImageView2(url: URL(string: images[index * 2 + 1].image_name)!) {
                                onTap(images[index * 2 + 1].id, images[index * 2 + 1].image_name)
                           }
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
