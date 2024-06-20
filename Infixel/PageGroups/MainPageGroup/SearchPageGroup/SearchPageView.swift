//
//  SearchPageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct SearchPageView: View {
    
    //private let baseColor: Color = .init(red: 232/255, green: 232/255, blue: 232/255)
    //private let shadowColor: Color = .init(red: 197/255, green: 197/255, blue: 197/255)
      
    //검색창 변수
    @State var searchValue = ""
    @State var placeHolder = "Search"
    @State var secure = false
    
    
    //
    //@State private var items: [Int] = []
    @State private var images: [String] = []
    
    
//    let columns = [
//            GridItem(.flexible()),  // 첫 번째 열
//            GridItem(.flexible()),  // 두 번째 열
//            GridItem(.flexible())   // 세 번째 열
//        ]
    
    @State private var selectedImage: String?
    @State private var showImageViewer: Bool = false
    
    @State private var cell_width = (UIScreen.main.bounds.width / 3) - 5
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                
                HStack {
                    VStack {
                        ZStack(alignment: .leading) {
                            if searchValue.isEmpty {
                                Text(placeHolder)
                                .bold()
                                .foregroundColor(Color.white.opacity(0.6))
                                //.padding()
                                .padding(.leading, 17)
                                .underline(true, color: .white.opacity(0.6))
                                .font(Font.custom("Bungee-Regular", size: 20))
                            } //if
                            TextField("", text: $searchValue)
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.leading, 17)
                                .frame(height: 50)
                
                        }//ZStack
                    }//VStack
                    .overlay(
                           RoundedRectangle(cornerRadius: 14)
                               .stroke(.white, lineWidth: 5)
                    )//overlay
                    .background(.black)
                    .cornerRadius(14)
                    .frame(width: geo.size.width*0.85)
                    
                    IconView(imageName: "search active", size: 38.0, padding: EdgeInsets(top: 2, leading:-5, bottom: 2, trailing: 10)) {
                        
                        if searchValue != "" {
                            searchTag(searchWord: searchValue)
                        }
                        
                        images = (1...10).map { _ in
                            "http://localhost:3000/image/randomjpg?\(index)=\(UUID().uuidString)"
                        }
                        
                    }//IconView
                }//HStack - 검색
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 3) {
                        ForEach(images, id: \.self) { imageLink in
                            AsyncImage(url: URL(string: imageLink)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: cell_width, height: cell_width)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: cell_width, height: cell_width)
                                        .clipped()
                                        .onTapGesture {
                                            selectedImage = imageLink
                                            showImageViewer = true
                                            print(imageLink)
                                        }//onTapGesture
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: cell_width, height: cell_width)
                                @unknown default:
                                    EmptyView()
                                }//phase
                            }//AsyncImage
                            .frame(width: cell_width, height: cell_width)
                            .background(Color.gray)
                            .cornerRadius(8)
                        }//ForEach
                    }//LazyVGrid
                    .padding(6)
                }//ScrollView
                     
            }//vstack
            .frame(width: geo.size.width)
            .sheet(isPresented: $showImageViewer, content: {
                if let selectedImage = selectedImage {
                    ImageViewer(imageUrl: selectedImage)
                    //ImageViewer(imageUrl: "https://image.blip.kr/v1/file/b321f5a3b77be82cd8822d04d7bb696d")
                }
            })
        }// geo
        .onAppear {
            //items = Array(1...100)
        }
        
        
    }
    
    func searchTag(searchWord: String) {
        guard let url = URL(string: VarCollectionFile.tagsSearchURL) else {
            print("Invalid URL")
            return
        }
        
        let body: [String: String] = ["search_word": searchWord]
        var request = URLRequest.post(url: url, body: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
              
                
            } else {
                print("Failed to send text to server")
            }
        }.resume()
        
    }
}



struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
