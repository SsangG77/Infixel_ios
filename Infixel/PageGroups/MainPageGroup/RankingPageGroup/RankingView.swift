//
//  RankingView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI

struct RankingView: View {
    @State private var activeTab: DummyTab = .image
    var offsetObserver = PageOffsetObserver()
    @EnvironmentObject var appState:AppState
    @State private var showImageViewer: Bool = false
    
    
    
    var body: some View {
        
        ZStack {
            
            TabView(selection: $activeTab) {
                RankingImageView(showImageViewer: $showImageViewer)
                    .environmentObject(appState)
                    .tag(DummyTab.image)
                    .background {
                        if !offsetObserver.isObserving {
                            FindCollectionView {
                                offsetObserver.collecttionVIew = $0
                                offsetObserver.observe()
                            }
                            
                        }
                    }
                
                RankingUserView()
                    .tag(DummyTab.user)
                    .background {
                        if !offsetObserver.isObserving {
                            FindCollectionView {
                                offsetObserver.collecttionVIew = $0
                                offsetObserver.observe()
                            }
                            
                        }
                    }
                
            }
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .never))
            
//TabView =======================================================================
            
            VStack {
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
                    .padding(.top, UIScreen.main.bounds.height * 0.07)
                
                Spacer()
            }//VStack
            
// Tabbar ======================================================================
                
            
            
        }
        //.padding(.top, 70)
        .ignoresSafeArea()
        .padding(.top, 20)
        .sheet(isPresented: $showImageViewer) {
            if let selectedImage = appState.selectedImage, let selectedImageId = appState.selectedImageId {
                ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
            } else {
                Text("Loading...")
            }
        }
//        .onReceive(appState.$selectedImage) { _ in
//            if appState.selectedImage != nil {
//                showImageViewer = true
//            }
//        }
        .onDisappear {
            showImageViewer = false
            print("랭킹 뷰 종료됨. ", showImageViewer)
        }
        
        
    }
 
    
    
    
    
    enum DummyTab: String, CaseIterable {
        case image = "Image"
        case user = "User"
        //case album = "test"
        
        var color: Color {
            switch self {
            case .image:
                return . red
            case .user:
                return . blue
//            case .album:
//                return . purple
            }
        }
    }
    
    
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
}

#Preview {
    RankingView()
}
