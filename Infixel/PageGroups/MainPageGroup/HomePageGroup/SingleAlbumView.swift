//
//  AddAlbum_singleAlbum_View.swift
//  Infixel
//
//  Created by 차상진 on 1/10/24.
//

import SwiftUI

struct SingleAlbumView: View {
    
    
//    @State var thumbnailLink = "https://data.ygosu.com/upload_files/board_stars/178822/654c1837ab3fb.webp"
//    @State var albumName = "test"
//    @State var created_at = "2024/05/13"
//    @State var count = 5
    
    //Binding
    @Binding var albumId:String
    @Binding var slideImage:SlideImage
    @Binding var thumbnailLink:String
    @Binding var albumName:String
    @Binding var created_at:String
    @Binding var count:Int
    
    //State
    @State private var isTapped = false
    
    var body: some View {
        GeometryReader { geo in
            
            HStack {
                Spacer()
                
                ZStack {
                    AsyncImageView(imageURL:$thumbnailLink)
                    VStack {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: isTapped ? .white : .black, location: 0.9)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    }
                    .clipped()
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(created_at)
                                .font(.system(size: 14, weight: .thin))
                            
                            Text(albumName)
                                .fontWeight(.heavy)
                                .font(Font.custom("Bungee-Regular", size: 35))
                                .padding(.bottom, 23)
                            
                            
                            Text(String(count))
                                .font(Font.system(size: 27))
                            
                        }
                        .foregroundStyle(.white)
                        .padding(.trailing)
                    }//HStack
                    
                }//ZStack
                .cornerRadius(20)
                .frame(width: geo.size.width * 0.94, height: 170)
                .clipped()
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                
                Spacer()
            }//HStack
            
        }//GeometryReader
        .onTapGesture {
            isTapped = true // 사용자가 탭하면 isTapped를 true로 설정
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isTapped = false // 0.5초 후에 isTapped를 false로 설정하여 원래 색으로 돌아감
            }
            VarCollectionFile.myPrint(title: "AddAlbum_singleAlbum_View", content: "id: \(albumId), image id : \(slideImage.id)")
            
            setAlbum_images(albumId: albumId, imageId: slideImage.id)
            
        } //onTapGesture
        
    }//body
    
    func setAlbum_images(albumId: String, imageId : String) {
        let params: [String:Any] = [
            "album_id" : albumId,
            "image_id" : imageId
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params)
        else {
            print("Failed to encode JSON")
            return
        }
        
        var request = URLRequest(url: URL(string: VarCollectionFile.imageSetAlbumURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error during URLSession: \(error.localizedDescription)")
                    return
                }
            
            if let data = data {
                do {
                    // JSON 디코딩
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let result = json["result"] as? Bool {
                            if result {
                                count+=1
                            }
                        } else {
                            print("Failed to get liked value")
                        }
                        
                    }//if let json
                } catch {
                    print("Error decoding JSON:", error)
                }//catch
            }//if let data
            
        }.resume()
        
        
        
        
    }
    
}

//#Preview {
//    AddAlbum_singleAlbum_View()
//}
