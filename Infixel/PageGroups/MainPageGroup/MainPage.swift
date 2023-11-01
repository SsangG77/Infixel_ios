//
//  MainView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct MainView: View {
    
//    @State var selectedTab: Tab = Tab.house
//    
//    enum Tab {
//        case house
//        case search
//        case plus
//        case save
//        case profile
//    }
    
    @Binding var isLoggedIn: Bool
    
    @ObservedObject var tabViewModel: TabViewModel = TabViewModel()
    @State var selectedTab: TabViewModel.Tab = .house
    
    
    
    var body: some View {
        
        ZStack {
            switch selectedTab {
            case .house:
                HomePageView()
            case .search:
                SearchPageView()
            case .plus:
                Text("사진 앨범 나오게 하기")
            case .save:
                SavePageView()
            case .profile:
                ProfilePageView(isLoggedIn: $isLoggedIn)
            
            }

            
            VStack {
                NavView(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
        }
        
        
        }
    }


//struct MainView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        MainView()
//    }
//}
