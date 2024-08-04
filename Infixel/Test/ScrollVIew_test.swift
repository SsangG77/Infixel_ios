import SwiftUI

struct ScrollView_test: View {
    
    @State private var slideImages: [SlideImage] = []
    
    @State private var isLoadingMore = false
    @State private var isInitialLoad = true
    
    
    @EnvironmentObject var appState: AppState
    
    @State private var reloadTriggers: [UUID] = []
    
    @Binding var slideImage:SlideImage
 

    var body: some View {
        if #available(iOS 17.0, *) {
            
            
            ZStack {
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(slideImages.indices, id: \.self) { index in
                            if let url = URL(string: slideImages[index].link) {
                                AsyncImage(url: url, transaction: Transaction(animation: .default)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                            .clipped()
                                            .onAppear {
                                                slideImage = slideImages[index]
                                                
                                                //마지막 이미지일때 동작
                                                if slideImages[index].id == slideImages.last?.id {
                                                    loadMorePhotosIfNeeded(currentPhoto: slideImages[index])
                                                }
                                            }
                                    case .failure:
                                        VStack {
                                            Image(systemName: "photo")
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            Text("Failed to load image, retrying...")
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                        .onAppear {
                                            reloadImage(photo: slideImages[index])
                                        }
                                    @unknown default:
                                        EmptyView()
                                    }//--@switch
                                }//--@AsyncImage
                                .id(reloadTriggers[index])
                            }//--@if_let_url
                        }//--@ForEach
                        .onChange(of: slideImage) {
                            appState.infoBoxReset = false
                        }
                        
                    }//--@LazyVStack
                }//--@Scrollview
                
                .scrollTargetBehavior(.paging)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if isInitialLoad {
                        loadInitialPhotos()
                    }
                }
                
                
                
                VStack {
                    Spacer()
                    if slideImages.count > 0 {
//                        Info_SubButtonView(slideImage: $slideImage)
//                            .frame(width: UIScreen.main.bounds.width - 34, height: 300, alignment: .bottom)
//                            .padding([.leading, .trailing], 17)
//                            .environmentObject(appState)
                    }
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.05 + UIScreen.main.bounds.height * 0.05)
                }//VStack
                
                
                ZStack {
                    if appState.albumsOpen || appState.commentsOpen {
                            Rectangle()
                                .foregroundColor(.secondary.opacity(0.1))
                                .background(.ultraThinMaterial)
                                .transition(.opacity)
                                .opacity(appState.albumsOpen || appState.commentsOpen ? 1.0 : 0.0)
                                .onTapGesture {
                                    withAnimation {
                                        appState.albumsOpen = false
                                        appState.commentsOpen = false
                                        appState.addAlbumOffset = 1000
                                        appState.commentsOffset = 1000
                                    }
                                }
                    }
                    
                }//ZStack - add album
                
            }//ZStack
            
            
            
            
            
            
            
            
            
        } else {
            // iOS 17이 아닐 때
            Text("iOS 17 버전 이상이 필요합니다.")
        }
    }
    
    
    //최초로 뷰가 생성될때 이미지 배열에 초기값 넣는 함수
    private func loadInitialPhotos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            reqImage()
            isInitialLoad = false
        }
    }
    //========================================================================
    
    
    //이미지 배열의 마지막에 도착했을때 추가로 이미지를 로드하는 함수
    private func loadMorePhotosIfNeeded(currentPhoto: SlideImage) {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            reloadTriggers.append(UUID())
            reqImage()
            isLoadingMore = false
        }
    }
    //========================================================================
    
    
    //이미지 로드에 실패했을때 리로드하는 함수
    private func reloadImage(photo: SlideImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let index = slideImages.firstIndex(where: { $0.id == photo.id }) {
                reloadTriggers[index] = UUID()
                let serverURL = URL(string: VarCollectionFile.randomImageURL)!
                
                let task = URLSession.shared.dataTask(with: serverURL) { (data, response, error) in
                    if let error = error {
                        print("요청 중 오류 발생: \(error)")
                    } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        if let data = responseString.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                   if let id = json["id"] as? String,
                                      let imageFileName = json["image_link"] as? String,
                                      let pic = json["pic"] as? Int,
                                      let description = json["description"] as? String,
                                      let userNick = json["user_at"] as? String,
                                      let userId = json["user_id"] as? String,
                                      let userProfileImage = json["profile_image"] as? String {
                                       let newSlideImage = SlideImage(id:id, link: imageFileName, pic: pic, description: description, user_nick: userNick, user_id: userId, profile_image: userProfileImage)
                                       DispatchQueue.main.async {
                                           slideImage = newSlideImage
                                           if slideImages.isEmpty {
                                               slideImages[index] = newSlideImage
                                           } else {
                                               withAnimation {
                                                   slideImages[index] = newSlideImage
                                               }
                                           }
                                       }
                                   }
                               }
                            } catch {
                                print("error : \(error)")
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    //========================================================================
    
    private func reqImage() {
        let serverURL = URL(string: VarCollectionFile.randomImageURL)!
        
        let task = URLSession.shared.dataTask(with: serverURL) { (data, response, error) in
            if let error = error {
                print("요청 중 오류 발생: \(error)")
            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                if let data = responseString.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           if let id = json["id"] as? String,
                              let imageFileName = json["image_link"] as? String,
                              let pic = json["pic"] as? Int,
                              let description = json["description"] as? String,
                              let userNick = json["user_at"] as? String,
                              let userId = json["user_id"] as? String,
                              let userProfileImage = json["profile_image"] as? String {
                               let newSlideImage = SlideImage(id:id, link: imageFileName, pic: pic, description: description, user_nick: userNick, user_id: userId, profile_image: userProfileImage)
                               DispatchQueue.main.async {
                                   if slideImages.isEmpty {
                                       slideImage = newSlideImage
                                       reloadTriggers.append(UUID())
                                       slideImages.append(newSlideImage)
                                   } else {
                                       withAnimation {
                                           reloadTriggers.append(UUID())
                                           slideImages.append(newSlideImage)
                                       }
                                   }
                               }
                           }
                       }
                    } catch {
                        print("error : \(error)")
                    }
                }
            }
        }
        task.resume()
    }
}


//#Preview {
//    ScrollView_test()
//}
