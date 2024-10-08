//
//  RankingImageSingleView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI

struct RankingImageSingleView: View {
    
    @Binding var ranking: Int
    @Binding var imageURL: String
    @Binding var pic: Int
    @Binding var profile_image: String
    @Binding var user_nick:String
    @Binding var description: String
    
    
    @State private var isTapped = false
    
    
    var width_ = UIScreen.main.bounds.width * 0.9
    var corner: CGFloat = 27
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        
        ZStack {
            GeometryReader { geo in
                AsyncImage(url: URL(string: imageURL), transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            

                    case .failure:
                        VStack {
                            Image(systemName: "photo")
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        
                    @unknown default:
                        EmptyView()
                    }//phase
                }//AsyncImage
            }//geo
            .clipShape(RoundedRectangle(cornerRadius: corner))
            .frame(width: width_)
            
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: isTapped ? .white : .black, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
            
            
            
            VStack {
                Text(String(ranking))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
                    .font(.system(size: 55))
                Spacer()
                
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom, spacing: 10) {
                            Image("pic!")
                                .resizable()
                                .frame(width: 37, height: 37)
                            
                            Text(String(pic))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .font(.system(size: 30))
                        }
                        
                        HStack {
                            AsyncImage(url: URL(string: profile_image)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        
                                       
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    EmptyView()
                                }//phase
                            }//AsyncImage
                            
                            Text("@" + user_nick)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                            
                        }//HStack
                    }//VStack
                    .padding(.leading, 5)
                    
                    Spacer()
                        
                    VStack {
                        Text(description)
                            .foregroundStyle(.white)
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                    }
                    .frame(width: 170)
                    
                }//HStack
                
            }//VStack
            .padding(20)
            
        }//ZStack
        .frame(width: width_, height: 450)
        .cornerRadius(corner)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), radius: 5, x: 2, y: 7)
        .padding()
        
    }
}

#Preview {
    RankingImageSingleView(ranking: .constant(1), imageURL: .constant(VarCollectionFile.resjpgURL + "1720700859535-777012927.jpg"), pic: .constant(751), profile_image: .constant(VarCollectionFile.resjpgURL + "1720457448108-211017711.jpg"), user_nick: .constant("user"), description: .constant("lidcasd;clknsc;lskdfnmaslk;cmsalcksldmca;sdcmasdl;kcmasdc;lkamsdc;al"))
}
