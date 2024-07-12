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
    
    
    
    
    
    var body: some View {
        
        
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
// Tabbar =============================================================================================
        
        TabView(selection: $activeTab) {
            
            RankingImageView()
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
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        
        
        
    }
    
    
    
    enum DummyTab: String, CaseIterable {
        case image = "Image"
        case user = "User"
        
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
