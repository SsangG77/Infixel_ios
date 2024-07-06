//
//  ImageViewer.swift
//  Infixel
//
//  Created by 차상진 on 6/13/24.
//

import SwiftUI



struct ImageViewer: View {
//    let imageUrl: String
//    let imageId: String
    @Binding var imageUrl: String
    @Binding var imageId: String
    
    
    @State var slideImage: SlideImage = SlideImage()
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            
            if let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
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
            } else {
                Text("Invalid URL")
            }
           
            
            
            VStack {
                Spacer()
                Info_SubButtonView(slideImage: $slideImage)
                .environmentObject(appState)
                .frame(width: UIScreen.main.bounds.width - 26, height: 300, alignment: .bottom)
            }//VStack
            
            if appState.albumsOpen_imageViewer || appState.commentOpen_imageViewer {
                Rectangle()
                    .foregroundColor(.secondary.opacity(0.1))
                    .background(.ultraThinMaterial)
                    .transition(.opacity)
                    .opacity(appState.albumsOpen_imageViewer || appState.commentOpen_imageViewer ? 1.0 : 0.0)
                    .onTapGesture {
                        withAnimation {
                            appState.albumsOpen_imageViewer = false
                            appState.commentOpen_imageViewer = false
                            appState.addAlbumOffset_imageViewer = 1000
                            appState.commentOffset_imageViewer = 1000
                        }
                    }
            }
            
            
            
            
            AddAlbumView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.addAlbumOffset_imageViewer)
                .animation(.easeInOut)
            
            CommentsView(slideImage: $slideImage)
                .environmentObject(appState)
                .offset(y : appState.commentOffset_imageViewer)
                .animation(.easeInOut)
            
            
        }//ZStack
        .onAppear {
            VarCollectionFile.myPrint(title: "image viewer", content: imageId)
            appState.imageViewerOrNot = true
            getImageFromId(imageId: imageId)
            
        }//onAppear
        .onDisappear {
            appState.infoBoxReset = false
            appState.imageViewerOrNot = false

            
            appState.commentsOpen = false
            appState.albumsOpen = false
            appState.commentsOffset = 1000
            appState.addAlbumOffset = 1000
            
            appState.commentOpen_imageViewer = false
            appState.commentOffset_imageViewer = 1000
            appState.albumsOpen_imageViewer = false
            appState.addAlbumOffset_imageViewer = 1000
        }
        
    }//body
    
    
    
    
    
    
    
    func getImageFromId(imageId: String) {
        guard let serverURL = URL(string: VarCollectionFile.imageIdURL) else {
            print("Invalid URL")
            return
        }
        
        let body: [String: String] = ["image_id": imageId]
        let request = URLRequest.post(url: serverURL, body: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data, let responseString = String(data: data, encoding: .utf8)  {
                    
                    if let data = responseString.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                               if let id = json["id"] as? String,
                                  let imageFileName = json["image_link"] as? String,
                                  let pic = json["pic"] as? Int,
                                  let description = json["description"] as? String,
                                  let userNick = json["user_at"] as? String,
                                  let userProfileImage = json["profile_image"] as? String
                                {
                                   let newSlideImage = SlideImage(id:id, link: imageFileName, pic: pic, description: description, user_nick: userNick, profile_image: userProfileImage)
                                  slideImage = newSlideImage
                                  
                                  
                               }//if let link, pic, description ...
                           }//if let json
                        } catch {
                            print("error : \(error)")
                        }//catch
                    }//if let data
                    
                    
                } else if let error = error {
                    VarCollectionFile.myPrint(title: "ImageViewer - error", content: error)
                }
                
            } else {
                print("Failed to send text to server")
            }
        }.resume()
        
    }
}

//#Preview {
//    ImageViewer(imageUrl: "http://localhost:3000/image/randomjpg", imageId: "imageid3")
//}
