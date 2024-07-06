//
//  SearchPageView_tag.swift
//  Infixel
//
//  Created by 차상진 on 6/28/24.
//

import SwiftUI

struct SearchPageView_tag: View {
    @Binding var images: [SearchSingleImage]
    @Binding var showImageViewer: Bool
    
    @State private var cell_width = (UIScreen.main.bounds.width / 3) - 5
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        
        ScrollView {
            
            if images.isEmpty || images.count != 0 {
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 3) {
                    ForEach(images, id: \.self) { single_image in
                        AsyncImage(url: URL(string: single_image.image_name)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: cell_width, height: cell_width)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cell_width, height: cell_width)
                                    .clipped()
                                    .onTapGesture {
                                        appState.selectImage(imageUrl: single_image.image_name, imageId: single_image.id)
                                        showImageViewer = true
                                    }//onTapGesture
                            case .failure:
                                Image(systemName: "photo")
                                    .frame(width: cell_width, height: cell_width)
                            @unknown default:
                                EmptyView()
                            }//phase
                        }//AsyncImage
                        .frame(width: cell_width, height: cell_width)
                        .background(Color.gray)
                        .cornerRadius(8)
                    }//ForEach
                }//LazyVGrid
                .padding(6)
                
            } else {
                Text("검색 결과가 없습니다.")
            }
            
        }//ScrollView
    }//body
    
    
}

//#Preview {
//    SearchPageView_tag()
//}
