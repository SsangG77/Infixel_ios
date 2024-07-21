//
//  SavePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI



class SavePageViewModel: ObservableObject {
    
    @Published var albumPlusClicked = false
    @Published var imageClicked = false
    
    
    
    func calculateScale(geometry: GeometryProxy) -> CGFloat {
            let midX = geometry.frame(in: .global).midX
            let screenWidth = UIScreen.main.bounds.width
            let threshold: CGFloat = screenWidth / 2
            
            // 중앙에서의 거리 계산
            let distance = abs(midX - screenWidth / 2)
            let scale = max(0.7, 1 - (distance / threshold) * 0.5)
            
            return scale
        }
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageView: View {
    
    @StateObject private var viewModel = SavePageViewModel()
    
    var body: some View {
        VStack {
            SavePageViewHeader()
                .environmentObject(viewModel)
            SavePageAlbumView()
                .environmentObject(viewModel)
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.albumPlusClicked) {
            SavePageAddAlbumView()
        }
        .sheet(isPresented: $viewModel.imageClicked) {
            Text("이미지")
        }
    }
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAddAlbumView: View {
    var body: some View {
        Text("앨범 추가 페이지")
        Text("앨범 이름, 앨범 썸네일 입력")
    }
}


//--@SavePageViewHeader-----------------------------------------------------------------------------------------------------------------------
struct SavePageViewHeader: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Albums")
                    .font(Font.custom("Bungee-Regular", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hexString: "4657F3"))
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hexString: "4657F3"))
                    .onTapGesture {
                        print("앨범 추가 버튼")
                        viewModel.albumPlusClicked = true
                    }
            }
            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .frame(height: 3)
            
        }
        .padding()
    }
}



//--@SavePageAlbumView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAlbumView: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    
    @State var albumName = "test"
    @State var albumImages = [
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL),
        SearchSingleImage(id: UUID().uuidString, image_name: VarCollectionFile.randomJpgURL)
    ]
    
    
    var body: some View {
        VStack {
            HStack {
                Text(albumName)
                    .font(Font.custom("Bungee-Regular", size: 20))
                Spacer()
            }
            .padding(.leading)

            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center) {
                    ForEach(albumImages) { image in
                        GeometryReader { geo in
                                Spacer()
                                AsyncImage(url: URL(string: image.image_name), transaction: Transaction(animation: .default)) { phase in
                                    switch phase {
                                        
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 150)
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                            .clipped()
                                            .cornerRadius(10)
                                            .scaleEffect(viewModel.calculateScale(geometry: geo))
                                            .onTapGesture {
                                                viewModel.imageClicked = true
                                            }
                                        
                                        
                                    case .failure:
                                        VStack {
                                            Image(systemName: "photo")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            Text("Failed to load image, retrying...")
                                                .foregroundColor(.white)
                                        }
                                        
                                    @unknown default:
                                        EmptyView()
                                    }//--@switch
                                }//--@AsyncImage
                                
                                
                            
                        }//--@geo
                        .frame(width: 120, height: 170)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 7, y: 5)
                        .containerRelativeFrame(.horizontal, count: 3, spacing: 5)
                        
                        
                        
                    }//--@ForEach
                    
                }//--@LazyHStack
                .scrollTargetLayout()
                .frame(height: 190)
                
            }//--@ScrollView
            
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 20)
            
            Divider()
                .padding()
            
        }
//        .frame(height: 210)
    }
}



struct SavePageView_Previews: PreviewProvider {
    static var previews: some View {
        SavePageView()
    }
}
