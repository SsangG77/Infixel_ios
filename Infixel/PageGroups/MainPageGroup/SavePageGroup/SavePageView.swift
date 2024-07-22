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
    @Published var albumIds = []
    @Published var imageId:String? = nil
    @Published var imageURL: String? = nil
    
    private var retryCount: [String: Int] = [:]
    
    
    func calculateScale(geometry: GeometryProxy) -> CGFloat {
        let midX = geometry.frame(in: .global).midX
        let screenWidth = UIScreen.main.bounds.width
        let threshold: CGFloat = screenWidth / 2
        
        // 중앙에서의 거리 계산
        let distance = abs(midX - screenWidth / 2)
        let scale = max(0.7, 1 - (distance / threshold) * 0.5)
        
        return scale
    }
    
    
    func retryImageLoading(url: String) {
        let maxRetries = 3
        let delay = 1.0
        
        if retryCount[url, default: 0] < maxRetries {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.retryCount[url, default: 0] += 1
                self.objectWillChange.send() // Trigger view update to retry loading
            }
        }
    }
    
    
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageView: View {
    
    @StateObject private var viewModel = SavePageViewModel()
    @StateObject private var addAlbumViewModel = AddAlbumViewModel()
    
    var body: some View {
        VStack {
            SavePageViewHeader()
                .environmentObject(viewModel)
            
            ScrollView {
                ForEach($addAlbumViewModel.albumList) { album in
                    SavePageAlbumView()
                        .environmentObject(viewModel)
                        .environmentObject(SavePageAlbumViewModel(albumId: album.id, albumName: album.album_name.wrappedValue))
                }
            }
            
            
            Spacer()
        }
        .onAppear {
            addAlbumViewModel.getAlbums()
        }
        .sheet(isPresented: $viewModel.albumPlusClicked) {
            SavePageAddAlbumView()
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
        VStack(spacing: 3) {
            HStack {
                Text("Albums")
                    .font(Font.custom("Bungee-Regular", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hexString: "4657F3"))
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hexString: "4657F3"))
                    .onTapGesture {
                        print("앨범 추가 버튼")
                        viewModel.albumPlusClicked = true
                    }
            }
            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .foregroundColor(Color(hexString: "4657F3"))
                .frame(height: 3)
            
        }
        .padding()
    }
}


//--@SavePageAlbumViewModel-------------------------------------------------------------------------------------------------------
class SavePageAlbumViewModel: ObservableObject {
    @Published var albumId:String
    @Published var albumName: String
    
    init(albumId: String, albumName: String) {
        self.albumId = albumId
        self.albumName = albumName
    }
    
    
}


//--@SavePageAlbumView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAlbumView: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    @EnvironmentObject var savePageAlbumViewModel: SavePageAlbumViewModel
    
    @StateObject var albumDetailViewModel = AlbumDetailViewModel()
    
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text(savePageAlbumViewModel.albumName)
                    .font(Font.custom("Bungee-Regular", size: 20))
                Spacer()
            }
            .padding(.leading)

            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center) {
                    ForEach(albumDetailViewModel.images) { image_ in
                        GeometryReader { geo in
                                Spacer()
                                AsyncImage(url: URL(string: image_.image_name), transaction: Transaction(animation: .default)) { phase in
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
                                                viewModel.imageId = image_.id
                                                viewModel.imageURL = image_.image_name
                                            }
                
                                    case .failure:
                                        VStack {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                                .scaleEffect(2)
                                        }
                                        .onAppear {
                                            viewModel.retryImageLoading(url: image_.image_name)
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
        .onAppear {
            albumDetailViewModel.searchAlbumImage(albumId: savePageAlbumViewModel.albumId)
        }
        .sheet(isPresented: $viewModel.imageClicked) {
//            Text("이미지")
            if let selectedImage = viewModel.imageURL, let selectedImageId = viewModel.imageId {
                ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
            } else {
                Text("Loading...")
            }
            
        }
//        .frame(height: 210)
    }
}



struct SavePageView_Previews: PreviewProvider {
    static var previews: some View {
        SavePageView()
    }
}
