import SwiftUI

struct NavView: View {
    
//    @State var selectedTab: Tab = Tab.house
//    
//    enum Tab {
//        case house
//        case search
//        case plus
//        case save
//        case profile
//    }
    
    
    @Binding var selectedTab:TabViewModel.Tab
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                
                ZStack {
                    VStack {
                        
                        Rectangle()
                            .foregroundColor(.secondary.opacity(0.1))
                            .background(.ultraThinMaterial)
                        
                        
                        
                    } //VStack
                    .frame(width: geometry.size.width * 0.92, height: 70)
                    .cornerRadius(26)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    
                    
                    HStack{
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .house
                        }) {
                            getImage(for: .house, isActive: selectedTab == .house)
                            
                        }
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .search
                        }) {
                            getImage(for: .search, isActive: selectedTab == .search)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .plus
                        }) {
                            getImage(for: .plus, isActive: selectedTab == .plus)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .save
                        }) {
                            getImage(for: .save, isActive: selectedTab == .save)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .profile
                        }) {
                            getImage(for: .profile, isActive: selectedTab == .profile)
                        }
                        
                        Spacer()
                        Spacer()
                    }//HStack
                    
                }// ZStack
            }//VStack
            .frame(height: geometry.size.height * 1.02)
            
        }
    }
    
    
    private func getImage(for tab: TabViewModel.Tab, isActive: Bool) -> some View {
        let imageName: String
        switch tab {
        case .house:
            imageName = isActive ? "house active" : "house inactive"
        case .search:
            imageName = isActive ? "search active" : "search inactive"
        case .plus:
            imageName = isActive ? "plus active" : "plus inactive"
        case .save:
            imageName = isActive ? "save active" : "save inactive"
        case .profile:
            imageName = isActive ? "profile active" : "profile inactive"
        }
        
        return Image(imageName)
            .resizable()
            .frame(width: 30, height: 30)
    }
}

//struct NavView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavView()
//    }
//}
