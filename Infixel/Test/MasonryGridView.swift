import SwiftUI

struct MasonryGrid: View {
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 10)
    ]
    
    let imageURLs = [
        "http://localhost:3000/image/resjpg?filename=haewon4.jpeg",
        "http://localhost:3000/image/resjpg?filename=winter1.jpeg",
        "http://localhost:3000/image/resjpg?filename=haewon.jpeg",
        "http://localhost:3000/image/resjpg?filename=haewon3.jpeg"
        // Add more image URLs as needed
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(imageURLs, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    MasonryGrid()
}
