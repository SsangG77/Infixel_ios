//
//  ProfilePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct ProfilePageView: View {
    
    //@Binding var isLoggedIn: Bool
    
    
    var body: some View {
        VStack {
            
            Text("Profile Page")
            Button("Log out") {
                //isLoggedIn = false
           }
           .font(.headline)
           .padding()
           .background(Color.blue)
           .foregroundColor(.white)
           .cornerRadius(10)
        }
    }
}

//struct ProfilePageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePageView()
//    }
//}
