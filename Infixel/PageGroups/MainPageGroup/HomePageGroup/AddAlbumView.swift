//
//  AddAlbumView.swift
//  Infixel
//
//  Created by 차상진 on 1/4/24.
//

import SwiftUI


class AddAlbumViewModel: ObservableObject {
    @Published var albumList:[Album] = []
    
    
    func getAlbums() {
        //유저 아이디로 앨범의 리스트를 가져온다.
        //앨범은 이름, 앨범 프로필, 앨범 id를 가져온다.
      
        guard let url = URL(string: VarCollectionFile.imageGetAlbumURL) else {
            print("Invalid URL")
            return
        }
        
        let jsonObject: [String: Any] = [
               "user_id": UserDefaults.standard.string(forKey: "user_id")!
           ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                print("Failed to encode JSON")
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Album].self, from: data) {
                    DispatchQueue.main.async {
                        self.albumList = decodedResponse
                    }
                } else {
                    print("JSON Decoding failed")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
            }.resume()
    }
    
}

struct AddAlbumView: View {
    
    @StateObject private var viewModel = AddAlbumViewModel()
    
    @State private var dragOffset: CGFloat = 0.0
    @Binding var slideImage:SlideImage
    
    @EnvironmentObject var appState: AppState
    
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Rectangle() //상단 핸들 모양
                        .frame(width: 40.0, height: 10)
                        .foregroundColor(Color(hexString: "F4F2F2"))
                        .cornerRadius(20)
                        .padding([.top, .bottom], 20)
                        .gesture(DragGesture()
                           .onChanged { value in
                               if appState.imageViewerOrNot {
                                   appState.addAlbumOffset_imageViewer = value.translation.height + 300
                               } else {
                                   appState.addAlbumOffset = value.translation.height + 300
                               }
                               
                           }
                            .onEnded { value in
                                if appState.imageViewerOrNot {
                                    if appState.addAlbumOffset_imageViewer > 250 {
                                        appState.addAlbumOffset_imageViewer = 1000
                                        appState.albumsOpen_imageViewer = false
                                    } else {
                                        appState.addAlbumOffset_imageViewer = 200
                                        appState.albumsOpen_imageViewer = true
                                    }
                                    
                                    
                                } else {
                                    if appState.addAlbumOffset > 250 {
                                        appState.addAlbumOffset = 1000
                                        appState.albumsOpen = false
                                    } else if appState.addAlbumOffset < 270 {
                                        appState.addAlbumOffset = 200
                                        appState.albumsOpen = true
                                    }
                                }
                            }
                       )
                }//VStack
                .frame(width: geo.size.width, height: 50)
                .background(.white)
                
                ScrollView() {
                    
                    ForEach($viewModel.albumList) { album in
                        SingleAlbumView(
                            albumId:album.id,
                            slideImage: $slideImage,
                            thumbnailLink: album.profile_link,
                            albumName: album.album_name,
                            created_at: album.created_at,
                            count: album.count
                        )
                        .frame(width: geo.size.width, height: 190)
                    }
                }
                
            }//VStack
            .background(Color.white) // VStack에 배경색 설정
            .cornerRadius(40)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.getAlbums()
                
            }
            
            
        }//GeometryReader
//        .onChange(of: appState.albumsOpen) { albumsOpen in
//            if albumsOpen {
//                if let userId = UserDefaults.standard.string(forKey: "user_id") {
//                    getAlbums(userId: userId)
//                }
//            }
//        }
        
        
    } // body view
    
        
}

//#Preview {
//    AddAlbumView()
//}
