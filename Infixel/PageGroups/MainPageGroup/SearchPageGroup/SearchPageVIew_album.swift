//
//  SearchPageVIew_album.swift
//  Infixel
//
//  Created by 차상진 on 6/29/24.
//

import SwiftUI

struct SearchPageView_album: View {
    @Binding var albums:[Album]
    
    @EnvironmentObject var appState: AppState
    
    var animationNamespace: Namespace.ID
    
    
    var body: some View {
        ScrollView {
            
            if !albums.isEmpty {
                ForEach($albums, id: \.self) { album in
                    SearchAlbumSingleView(album: album, animationNamespace: animationNamespace)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                appState.selectedAlbum = album.wrappedValue
                            }
                        }
                }
                
            } else {
                Text("검색된 결과가 없습니다.")
            }
            
        }
    }
}



class AlbumDetailViewModel: ObservableObject {
    @Published var images: [SearchSingleImage] = []
    
    
    
    func searchAlbumImage(albumId: String) {
        guard let url = URL(string: VarCollectionFile.searchAlbumImageURL) else {
            return
        }
        
        let body: [String: String] = ["album_id": albumId]
        let request = URLRequest.post(url: url, body: body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
            
            
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode([SearchSingleImage].self, from: data) {
                        DispatchQueue.main.async {
                            self.images = decodedResponse
                        }
                    }
                } else if let error = error {
                    VarCollectionFile.myPrint(title: "SearchPageView_album", content: error)
                } else {
                    print("Failed to send text to server")
                }
                
            }.resume()
        }
    }//searchAlbumImage
    
    
    func deleteImage(_ id: String, _ albumId: String) {
        
        
        if let index = images.firstIndex(where: {$0.id == id}) {
            images.remove(at: index)
        }
        
        
        guard let url = URL(string: VarCollectionFile.deleteImageFromAlbumURL) else {
            return
        }
        
        let request = URLRequest.post(url: url, body: ["image_id": id, "album_id": albumId])
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let result = json["result"] as? Bool {
                                print(result)
                            }
                        }
                    } catch {
                        print("Error decoding JSON:", error)
                    }
                }
                
                
            }.resume()
        }
        
        
        
    }//deleteImage
    
}








struct AlbumDetailView: View {
    
    //원래 변수
        @Binding var album:Album!
        var animationNamespace: Namespace.ID
        var onClose: () -> Void

    
    @EnvironmentObject var appState: AppState
    @State private var showImageViewer: Bool = false
    @State private var imageHeights: [String: CGFloat] = [:]

    
    //
    @State private var headerHeight: CGFloat = 330
    let minHeight: CGFloat = 140
    @State private var textPadding: CGFloat = 20 // 텍스트 패딩
    @State private var showButton: Bool = false // 버튼 표시 상태
    
    
    @StateObject private var viewModel = AlbumDetailViewModel()

    
    
    //=============================================================
    var body: some View {
            ZStack(alignment: .top) {
                ScrollView {
                    GeometryReader { geometry in
                        Color.clear
                            .frame(height: 0)
                            .onChange(of: geometry.frame(in: .global).minY) { newValue in
                                let newHeight = 330 + newValue
                                headerHeight = max(minHeight, newHeight)
                                textPadding = 10 // 텍스트 패딩 조정
                                showButton = newHeight <= minHeight
                            }//onChange
                    }//GeometryReader
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: headerHeight)
                        
                        
                        ImageGridView(images: $viewModel.images) { imageId, imageName in
                            appState.album_selectedImage = imageName
                            appState.album_selectedImageId = imageId
                            showImageViewer = true
                        }
                        
                    }//VStack
                }//ScrollView
                
                
                if let album = album {
                    ZStack {
                        //zstack - 1
                        AsyncImage(url: URL(string: album.profile_link)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                                    .clipped()
                            } else if phase.error != nil {
                                Text("Failed to load image")
                                    .foregroundColor(.red)
                                    .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                            } else {
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                            }
                        }//AsyncImage
                        
                        
                        //zstack - 2
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .white, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                            .frame(width: UIScreen.main.bounds.width, height: headerHeight)
                        
                        //zstack - 3
                        
                        VStack {
                            if !showButton {
                                HStack {
                                    IconView(imageName: "left-arrow", size: 30.0, padding: EdgeInsets(top: 0, leading:20, bottom: 5, trailing: 0)) {
                                        onClose()
                                    }
                                    Spacer()
                                }
                                
                            }// if
                            
                            
                            HStack {
                                if showButton {
                                    IconView(imageName: "left-arrow", size: 30.0, padding: EdgeInsets(top: 0, leading:20, bottom: 5, trailing: 0)) {
                                        onClose()
                                    }
                                }// if
                                VStack(alignment: .leading) {
                                    Text(album.created_at)
                                        .font(.system(size: 14, weight: .thin))
                                        .padding(.leading, 10)
                                    
                                    Text(album.album_name)
                                        .fontWeight(.heavy)
                                        .font(Font.custom("Bungee-Regular", size: 35))
                                        .padding(.bottom, 23)
                                }//VStack
                                .foregroundStyle(.black)
                                .padding(.leading, textPadding)
                                Spacer()
                                
                                Text(String(album.count))
                                //.font(Font.system(size: 18))
                                    .font(Font.custom("Bungee-Regular", size: 20))
                                    .padding(.top, 10)
                                    .padding(.trailing, 20)
                            }//HStack
                            .padding(.bottom, 40)
                            .offset(y: headerHeight * 0.4)
                        }
                        
                        
                    }//Zstack
                    .padding(.bottom, 20)
                    .frame(height: headerHeight)
                    .matchedGeometryEffect(id: album.id, in: animationNamespace)
                }// if
                
                
            }//ZStack
            .background(Color.white)
            .animation(.easeInOut, value: headerHeight)
            .frame(height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .onAppear {
                viewModel.searchAlbumImage(albumId: album.id)
            }
            .onDisappear {
                showImageViewer = false
                appState.album_selectedImage = nil
                appState.album_selectedImageId = nil
            }
            .sheet(isPresented: $showImageViewer) {
                if let selectedImage = appState.album_selectedImage, let selectedImageId = appState.album_selectedImageId {
                    ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
                } else {
                    Text("Loading...")
                }
            }
            .onReceive(appState.$album_selectedImage) { _ in
                if appState.album_selectedImage != nil {
                    showImageViewer = true
                }
            }
        
        
        
        
        
        
        }//body
    
    //=============================================================
    

    
    
}//AlbumDetailView





//#Preview {
//    AlbumDetailView()
//}
