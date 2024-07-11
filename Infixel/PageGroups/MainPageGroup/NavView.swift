import SwiftUI

struct NavView: View {
  
    @EnvironmentObject var appState: AppState
    
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
                            appState.selectedTab = .house
                        }) {
                            getImage(for: .house, isActive: appState.selectedTab == .house)
                            
                        }
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            appState.selectedTab = .search
                        }) {
                            getImage(for: .search, isActive: appState.selectedTab == .search)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            appState.selectedTab = .chart
                        }) {
                            getImage(for: .chart, isActive: appState.selectedTab == .chart)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            appState.selectedTab = .save
                        }) {
                            getImage(for: .save, isActive: appState.selectedTab == .save)
                        }
                        
                        Spacer()
                        
                        Image("vertical_line")
                        
                        Spacer()
                        
                        Button(action: {
                            appState.selectedTab = .profile
                        }) {
                            getImage(for: .profile, isActive: appState.selectedTab == .profile)
                        }
                        
                        Spacer()
                        Spacer()
                    }//HStack
                    
                }// ZStack
                .frame(height: UIScreen.main.bounds.height * 0.05)
            }//VStack
            //.frame(height: geometry.size.height * 1.02)
            
            
        }
    }
    
    
    private func getImage(for tab: AppState.Tab, isActive: Bool) -> some View {
        let imageName: String
        switch tab {
        case .house:
            imageName = isActive ? "house active" : "house inactive"
        case .search:
            imageName = isActive ? "search active" : "search inactive"
        case .chart:
            imageName = isActive ? "chart active" : "chart inactive"
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
