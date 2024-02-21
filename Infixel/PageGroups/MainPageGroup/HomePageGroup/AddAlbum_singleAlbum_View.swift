//
//  AddAlbum_singleAlbum_View.swift
//  Infixel
//
//  Created by 차상진 on 1/10/24.
//

import SwiftUI

struct AddAlbum_singleAlbum_View: View {
    
    
    //@State var thumbnailURL = "http://localhost:3000/randomjpg"
    @Binding var thumbnailLink:String

    @Binding var albumName:String
    
    var body: some View {
        
        
        GeometryReader { geo in
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .frame(width: geo.size.width * 0.9, height: 100)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                    
                    
                    HStack {
                        VStack {
                            AsyncImageView(imageURL: URL(string: thumbnailLink))
                                .cornerRadius(10)
                        }//AsyncImageView - VStack
                        .frame(width: 70, height: 70)
                        .clipped()
                        .padding(.trailing, 20)
                        
                        Text(albumName)
                            .font(Font.custom("Bungee-Regular", size: 17))
                        
                        Spacer()
                    }//HStack
                    .padding(.leading, 33)
                    
                }//ZStack
                .frame(width: geo.size.width, height: 130)
                .clipped()
            }//VStack
            //.frame(width: geo.size.width, height: 180)
        }
        
        
        
        
    }
}

//#Preview {
//    AddAlbum_singleAlbum_View()
//}
