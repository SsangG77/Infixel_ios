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
                
                HStack {
                    VStack {
                        ZStack(alignment: .leading) {
                            if searchValue.isEmpty {
                                Text(placeHolder)
                                .bold()
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.leading, 17)
                                .underline(true, color: .white.opacity(0.6))
                                .font(Font.custom("Bungee-Regular", size: 20))
                            } //if
                            TextField("", text: $searchValue, onCommit: {
                                if searchValue != "" {
                                    searchTag(searchWord: searchValue, type:0)
                                    appState.searchBtnClicked = true
                                }
                            })
                            .onChange(of : searchValue) { newValue in
                                VarCollectionFile.myPrint(title: "search value onchange", content: searchValue)
                                searchPageUserOnAppear = true
                                searchPageAlbumOnAppear = true
                            }
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding(.leading, 17)
                            .frame(height: 50)
                
                        }//ZStack
                    }//VStack
                    .overlay(
                           RoundedRectangle(cornerRadius: 14)
                               .stroke(.white, lineWidth: 6)
                    )//overlay
                    .background(.black)
                    .cornerRadius(14)
                    .frame(width: UIScreen.main.bounds.width*0.85)
                    
                    IconView(imageName: "search active", size: 30.0, padding: EdgeInsets(top: 2, leading:-5, bottom: 2, trailing: 10)) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if searchValue != "" {
                            searchTag(searchWord: searchValue, type: 0)
                            appState.searchBtnClicked = true
                        }
                        
                    }//IconView
                }//HStack - 검색
                //=============================================================
                
                
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
            .onReceive(appState.$selectedImage) { _ in
                if appState.selectedImage != nil {
                    showImageViewer = true
                }
            }
            .onDisappear {
                appState.searchBtnClicked = false
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










//@available(iOS 17.0, *)
//@Observable
//class PageOffsetObserver: NSObject {
//    var collecttionVIew: UICollectionView?
//    var offset: CGFloat = 0
//    private(set) var isObserving: Bool = false
//    
//    deinit {
//        remove()
//    }
//    
//    func observe() {
//        guard !isObserving else { return }
//        collecttionVIew?.addObserver(self, forKeyPath: "contentOffset", context: nil)
//        isObserving = true
//    }
//    
//    func remove() {
//        collecttionVIew?.removeObserver(self, forKeyPath: "contentOffset")
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard keyPath == "contentOffset" else { return }
//        if let contentOffset = (object as? UICollectionView)?.contentOffset {
//            offset = contentOffset.x
//        }
//    }
//    
//    
//}//PageOffsetObserver



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



//struct SearchPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchPageView()
//    }
//}
