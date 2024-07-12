//
//  RankingImageSingleView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI

struct RankingImageSingleView: View {
//    @State var imageURL = VarCollectionFile.resjpgURL + "winter6.jpeg"
//    @State var ranking  = 1
//    @State var pic = 751
//    @State var profile_image = VarCollectionFile.resjpgURL + "1720457448108-211017711.jpg"
//    @State var user_nick = "user_sj"
//    @State var desciption = "lorem ipsum seekcdospzedqewr"
    
    @Binding var ranking: Int
    @Binding var imageURL: String
    @Binding var pic: Int
    @Binding var profile_image: String
    @Binding var user_nick:String
    @Binding var description: String
    
    
    @State private var isTapped = false
    
    
    var width_ = UIScreen.main.bounds.width * 0.9
    var corner: CGFloat = 27
    
    var body: some View {
        
        
        
        ZStack {
            GeometryReader { geo in
                                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .position(x: geo.size.width/2, y: geo.size.height/2)
                                            
                
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }//phase
                                }//AsyncImage
            }
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
                    .font(.system(size: 45))
                Spacer()
                
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 10) {
                            Image("pic!")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(String(pic))
                                .foregroundStyle(.white)
                                .fontWeight(.heavy)
                                .font(.system(size: 25))
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
                            
                        }
                    }//VStack
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    Text(description)
                        .foregroundStyle(.white)
                        .fontWeight(.regular)
                    
                    
                }
                
                
                
            }
            .padding(20)
            
            
            
            
        }
        .frame(width: width_, height: 450)
        .cornerRadius(corner)
        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 4)
        .padding()
        
        
        
        
    }
}

#Preview {
    RankingImageSingleView(ranking: .constant(1), imageURL: .constant(VarCollectionFile.resjpgURL + "1720700859535-777012927.jpg"), pic: .constant(751), profile_image: .constant(VarCollectionFile.resjpgURL + "1720457448108-211017711.jpg"), user_nick: .constant("user"), description: .constant("ddddd"))
}
