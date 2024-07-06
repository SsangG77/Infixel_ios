//
//  SearchAlbumSingleView.swift
//  Infixel
//
//  Created by 차상진 on 7/1/24.
//

import SwiftUI

struct SearchAlbumSingleView: View {
    
//        @Binding var thumbnailLink:String
//       @State var albumName = "test"
//       @State var created_at = "2024/05/13"
//       @State var count = 5
    @Binding var album:Album
    var animationNamespace: Namespace.ID
    
    
    var body: some View {
            HStack {
                Spacer()
                
                ZStack {
                    AsyncImageView(imageURL:$album.profile_link)
                    VStack {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .black, location: 0.9)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    }
                    .clipped()
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(album.created_at)
                                .font(.system(size: 14, weight: .thin))
                            
                            Text(album.album_name)
                                .fontWeight(.heavy)
                                .font(Font.custom("Bungee-Regular", size: 35))
                                .padding(.bottom, 23)
                            
                            
                            Text(String(album.count))
                                .font(Font.system(size: 27))
                            
                        }
                        .foregroundStyle(.white)
                        .padding(.trailing)
                    }//HStack
                    
                }//ZStack
                .cornerRadius(20)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 170)
                .clipped()
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                
                Spacer()
            }//HStack
            .padding([.top, .bottom], 5)
            .matchedGeometryEffect(id: album.id, in: animationNamespace)
            
        
    }
}

//#Preview {
//    SearchAlbumSingleView()
//}
