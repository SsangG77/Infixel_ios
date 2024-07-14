//
//  SearchPageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI



@available(iOS 17.0, *)
struct SearchPageView: View {
    
    //검색창 변수
    @State var searchValue = ""
    @State var placeHolder = "Search"
    @State var secure = false
    @State private var images: [SearchSingleImage] = []
    @State private var users: [SearchSingleUser] = []
    @State private var albums: [Album] = []
    @State private var selectedImage: String?
    @State private var selectedImageId: String?
    
    @State var searchPageUserOnAppear = true
    @State var searchPageAlbumOnAppear = true
    
    
    @State private var showImageViewer: Bool = false
    

    @FocusState var FocusState
    
    @EnvironmentObject var appState: AppState
    
    //탭뷰용
    @State private var selectedTab = 0
    @State private var activeTab: DummyTab = .tag
    var offsetObserver = PageOffsetObserver()
    
    //search album
    var animationNamespace: Namespace.ID
    
    enum DummyTab: String, CaseIterable {
        case tag = "Tag"
        case user = "User"
        case album = "Album"
        
        var color: Color {
            switch self {
            case .tag:
                return . red
            case .user:
                return . blue
            case .album:
                return . purple
            }
        }
    }
    
    
    
    var body: some View {
        
            VStack {
                
                VStack {
                    TextField(placeHolder, text:$searchValue, onCommit: {
                        if searchValue != "" {
                            searchTag(searchWord: searchValue, type:0)
                            appState.searchBtnClicked = true
                        }
                    })
                    .onChange(of : searchValue) { newValue in
                        searchPageUserOnAppear = true
                        searchPageAlbumOnAppear = true
                    }
                    .padding(10)
                    .padding(.bottom, 5)
                    .frame(height: 50)
                    .background(.gray.opacity(0.3), in: .rect(cornerRadius: 12))
                    .focused($FocusState)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 2)
                            .foregroundStyle(FocusState ? .blue : .clear)
                    }
                    
                }
                .padding([.leading, .trailing], 10)
                
                
                
                
                
                Tabbar(.gray)
                    .overlay {
                        if let collectionViewBounds = offsetObserver.collecttionVIew?.bounds {
                            GeometryReader {
                                let width = $0.size.width
                                let tabCount = CGFloat(DummyTab.allCases.count)
                                let capsuleWidth = width/tabCount
                                let progress = offsetObserver.offset / collectionViewBounds.width
                                
                                Capsule()
                                    .fill(.black)
                                    .frame(width: capsuleWidth)
                                    .offset(x: progress * capsuleWidth)
                                
                                Tabbar(.white, .semibold)
                                    .mask(alignment: .leading) {
                                        Capsule()
                                            .frame(width: capsuleWidth)
                                            .offset(x: progress * capsuleWidth)
                                    }
                            }
                        }
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                
                TabView(selection: $activeTab) {
                    
                    VStack {
                        //태그로 검색된 이미지가 나옴
                        SearchPageView_tag(images: $images, showImageViewer: $showImageViewer)
                            .tag(DummyTab.tag)
                            .frame(height: UIScreen.main.bounds.height * 0.7)
                            .background {
                                if !offsetObserver.isObserving {
                                    FindCollectionView {
                                        offsetObserver.collecttionVIew = $0
                                        offsetObserver.observe()
                                    }
                                    
                                }
                            }
                            Spacer()
                    }
                    
                    VStack {
                        //검색된 유저가 나옴
                        SearchPageView_user(users: $users)
                            .tag(DummyTab.user)
                            .frame(height: UIScreen.main.bounds.height * 0.7)
                            .background {
                                if !offsetObserver.isObserving {
                                    FindCollectionView {
                                        offsetObserver.collecttionVIew = $0
                                        offsetObserver.observe()
                                    }
                                    
                                }
                            }
                            .onAppear {
                                if appState.searchBtnClicked && searchPageUserOnAppear {
                                    searchTag(searchWord: searchValue, type: 1)
                                    searchPageUserOnAppear = false
                                }
                                
                            }
                        Spacer()
                        
                    }
                    
                    VStack {
                        //검색된 앨범이 나옴
                        SearchPageView_album(albums: $albums, animationNamespace: animationNamespace)
                            .tag(DummyTab.album)
                            .frame(height: UIScreen.main.bounds.height * 0.7)
                            .background {
                                if !offsetObserver.isObserving {
                                    FindCollectionView {
                                        offsetObserver.collecttionVIew = $0
                                        offsetObserver.observe()
                                    }
                                    
                                }
                            }
                            .onAppear {
                                if appState.searchBtnClicked && searchPageAlbumOnAppear {
                                    searchTag(searchWord: searchValue, type: 2)
                                    searchPageAlbumOnAppear = false
                                }
                            }
                        Spacer()
                    }
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                //검색된 태그 이미지 나오는 부분
                
                //==============================================================
                
                
            }//vstack
            .frame(width: UIScreen.main.bounds.width)
            .sheet(isPresented: $showImageViewer) {
                if let selectedImage = appState.selectedImage, let selectedImageId = appState.selectedImageId {
                    ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
                } else {
                    Text("Loading...")
                }
            }
//            .onReceive(appState.$selectedImage) { _ in
//                if appState.selectedImage != nil {
//                    showImageViewer = true
//                }
//            }
            .onDisappear {
                appState.searchBtnClicked = false
                showImageViewer = false
                images.removeAll()
                users.removeAll()
                albums.removeAll()
            }
            
            
            //------------------------
            
        
        
    }//body
    
    
    
    
    
    //--@searchTag ===============================================================
    func searchTag(searchWord: String, type: Int) {
        
        var urlString: String = ""
        
        if type == 0 {
            urlString = VarCollectionFile.tagsSearchURL
        } else if type == 1 {
            urlString = VarCollectionFile.userSearchURL
        } 
        else if type == 2 {
            urlString = VarCollectionFile.albumSearchURL
        } 
        else {
            print("Invalid type")
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let body: [String: String] = ["search_word": searchWord]
        let request = URLRequest.post(url: url, body: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                // 응답 데이터 처리
                if type == 0 {
                    if let decodedResponse = try? JSONDecoder().decode([SearchSingleImage].self, from: data) {
                        DispatchQueue.main.async {
                            self.images = decodedResponse
                        }
                    }
                } else if type == 1 {
                    if let decodedResponse = try? JSONDecoder().decode([SearchSingleUser].self, from: data) {
                        DispatchQueue.main.async {
                            self.users = decodedResponse
                        }
                    }
                } 
                else if type == 2 {
                    if let decodedResponse = try? JSONDecoder().decode([Album].self, from: data) {
                        DispatchQueue.main.async {
                            self.albums = decodedResponse
                        }
                    }
                }
            } else if let error = error {
                VarCollectionFile.myPrint(title: "SearchPageView", content: error)
            } else {
                print("Failed to send text to server")
            }
        }.resume()
    }

    //===========================================================================
    
    
    
    
    
    //--@Scrollable_Tab_Bar========================
    
    @ViewBuilder
    func Tabbar(_ tint: Color, _ weight: Font.Weight = .regular) -> some View {
        HStack(spacing: 0) {
            ForEach(DummyTab.allCases, id: \.rawValue) {tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(weight)
                    .foregroundStyle(tint)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                            activeTab = tab
                        }
                    }
            }
        }
    }
    //=============================================
    
}


struct FindCollectionView: UIViewRepresentable {
    var result: (UICollectionView) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let collectionView = view.collectionSuperView {
                result(collectionView)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}//FindCollectionView


extension UIView {
    var collectionSuperView: UICollectionView? {
        if let collectionSuperView = superview as? UICollectionView {
            return collectionSuperView
        }
        
        return superview?.collectionSuperView
    }
}//extension



