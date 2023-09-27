//
//  TabViewModel.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/19.
//

import Foundation
import SwiftUI

class TabViewModel: ObservableObject {
    @Published var selectedTab: Tab = Tab.house
    
    enum Tab {
        case house
        case search
        case plus
        case save
        case profile
    }
}
