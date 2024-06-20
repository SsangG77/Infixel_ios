//
//  AddAlbumView.swift
//  Infixel
//
//  Created by 차상진 on 1/4/24.
//

import SwiftUI


struct AddAlbumView: View {
    
    @State var albumList:[Album] = []
    
    @Binding var slideImage:SlideImage
    
    @Binding var albumsOpen:Bool
    
    let _height = 800.0
    
    @State private var dragOffset: CGFloat = 0.0
    @Binding var addAlbumOffset : CGFloat
    
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
                               // Update dragOffset based on drag gesture
                               addAlbumOffset = value.translation.height + 300
                               print(addAlbumOffset)
                           }
                            .onEnded { value in
                                if addAlbumOffset > 250 {
                                    addAlbumOffset = 1000
                                    albumsOpen = false
                                } else if addAlbumOffset < 270 {
                                    addAlbumOffset = 200
                                    albumsOpen = true
                                }
                            }
                       )
                }//VStack
                .frame(width: geo.size.width, height: 50)
                .background(.white)
                
                ScrollView() {
                    
                    ForEach($albumList) { album in
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
            
            
        }//GeometryReader
        .onChange(of: albumsOpen) { albumsOpen in
            if albumsOpen {
                if let userId = UserDefaults.standard.string(forKey: "user_id") {
                    VarCollectionFile.myPrint(title: "AddAlbumView - onChange userId", content: userId)
                    getAlbums(userId: userId)
                }
                }
            
        }
        
        
    } // body view
    
    func getAlbums(userId:String) {
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

//#Preview {
//    AddAlbumView()
//}