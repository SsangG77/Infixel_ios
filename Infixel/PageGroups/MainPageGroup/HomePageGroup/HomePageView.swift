//
//  HomePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//
import SwiftUI
import Combine


@available(iOS 17.0, *)
struct HomePageView: View {
    @EnvironmentObject var appState: AppState
    @Binding var slideImage: SlideImage
    @State private var isActive: Bool = false
    
    
    //@StateObject private var viewModel: HomePageViewModel
    @State var slideImages: [SlideImage] = []
    @State var reloadTriggers: [UUID] = []
    @State var isInitialLoad = true
    @State var isLoadingMore = false
    
    @State var profile = false
    @State var isLoggedIn = true
    

    init(slideImage: Binding<SlideImage>) {
        self._slideImage = slideImage
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white] // 뒤로가기 버튼 텍스트 색 설정
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ProfilePageView(isLoggedIn: $isLoggedIn, userId: $slideImage.user_id, profile: $profile),
                    isActive: $isActive,
                    label: {
                        EmptyView() // Label을 빈 뷰로 설정하여 숨김
                    }
                )
            
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(slideImages.indices, id: \.self) { index in
                            if let url = URL(string: slideImages[index].link) {
                                GeometryReader { geo in
                                    AsyncImage(url: url, transaction: Transaction(animation: .default)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .position(x: geo.size.width / 2, y: geo.size.height / 2)
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
                                                
                                            }
                                            .onAppear {
                                                reloadImage(photo: slideImages[index])
                                            }
                                        @unknown default:
                                            EmptyView()
                                        }//--@switch
                                    }//--@AsyncImage
                                    .id(reloadTriggers[index])
                                }
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            }//--@if_let_url
                        }//--@ForEach
                        .onChange(of: slideImage) { _ in
                            withAnimation {
                                appState.infoBoxReset = false
                            }
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
                    HStack {
                        Spacer()
                        NavigationLink(destination: AlarmView()) {
                            bellButtonView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
//                        bellButtonView()
//                            .padding(.trailing, 5)
                        
                        UploadImagePlusView()
                            .contentTransition(.symbolEffect)
//                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                            .environmentObject(appState)
                            .onTapGesture {
                                withAnimation {
                                    appState.uploadPlusBtnClicked.toggle()
                                }
                            }
                    }
                    
                    Spacer()
                    if slideImages.count > 0 {
                        Info_SubButtonView(slideImage: $slideImage,isActive: $isActive)
                            .frame(width: UIScreen.main.bounds.width - 34, height: 300, alignment: .bottom)
                            .padding([.leading, .trailing], 17)
                            .environmentObject(appState)
                    }
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.05 + UIScreen.main.bounds.height * 0.05)
                }//VStack
                
                if appState.albumsOpen || appState.commentsOpen || appState.threeDotsOpen {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.1))
                        .background(.ultraThinMaterial)
                        .transition(.opacity)
                        .opacity(appState.albumsOpen || appState.commentsOpen || appState.threeDotsOpen ? 1.0 : 0.0)
                        .onTapGesture {
                            withAnimation {
                                appState.albumsOpen = false
                                appState.commentsOpen = false
                                appState.threeDotsOpen = false
                                
                                appState.addAlbumOffset = 1000
                                appState.commentsOffset = 1000
                                appState.threeDotsOffset = 2000
                            }
                        }
                }
                
                
                if appState.uploadPlusBtnClicked {
                    GeometryReader { geo in
                        UploadImageView()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .contentTransition(.symbolEffect)
                            .background(Color.white)
                    }
                }
            }//ZStack
        }
        .accentColor(.white)
    }//body
    
    func loadMorePhotosIfNeeded(currentPhoto: SlideImage) {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reloadTriggers.append(contentsOf: [UUID(), UUID(), UUID()])
            self.reqImage()
            self.reqImage()
            self.reqImage()
            self.isLoadingMore = false
        }
    }
    
    func reloadImage(photo: SlideImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let index = self.slideImages.firstIndex(where: { $0.id == photo.id }) {
                self.reloadTriggers[index] = UUID()
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
                                       let newSlideImage = SlideImage(id: id, link: imageFileName, pic: pic, description: description, user_nick: userNick, user_id: userId, profile_image: userProfileImage)
                                       DispatchQueue.main.async {
                                           if self.slideImages.isEmpty {
                                               self.slideImages[index] = newSlideImage
                                           } else {
                                               withAnimation {
                                                   self.slideImages[index] = newSlideImage
                                               }
                                           }
                                       }
                                   }
                               }
                            } catch {
                                VarCollectionFile.myPrint(title: "HomePageViewModel - reloadImage() Error", content: error)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    
    func loadInitialPhotos() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reqImage()
            self.isInitialLoad = false
        }
    }
    
    func reqImage() {
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
                               let newSlideImage = SlideImage(id: id, link: imageFileName, pic: pic, description: description, user_nick: userNick, user_id: userId, profile_image: userProfileImage)
                               DispatchQueue.main.async {
                                   if self.slideImages.isEmpty {
                                       slideImage = newSlideImage
                                       
                                       self.reloadTriggers.append(UUID())
                                       self.slideImages.append(newSlideImage)
                                   } else {
                                       withAnimation {
                                           self.reloadTriggers.append(UUID())
                                           self.slideImages.append(newSlideImage)
                                       }
                                   }
                               }
                           }
                       }
                    } catch {
                        VarCollectionFile.myPrint(title: "HomePageViewModel - reqImage() Error", content: error)
                    }
                }
            }
        }
        task.resume()
    }
    
}





//#Preview {
//    HomePageView(slideImage: .constant(SlideImage()))
//}
