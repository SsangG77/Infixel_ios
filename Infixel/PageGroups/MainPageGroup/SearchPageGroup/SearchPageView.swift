//
//  SearchPageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI

struct SearchPageView: View {
    //검색창 변수
    @State var searchValue = ""
    @State var placeHolder = "Search"
    @State var secure = false
    @State private var images: [SearchSingleImage] = []
    @State private var selectedImage: String?
    @State private var selectedImageId: String?
    @State private var cell_width = (UIScreen.main.bounds.width / 3) - 5
    
    //@StateObject private var viewModel = ImageViewModel()
    @State private var showImageViewer: Bool = false
    
    
    @EnvironmentObject var appState: AppState
    
    
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
                            TextField("", text: $searchValue, onCommit: {
                                if searchValue != "" {
                                    searchTag(searchWord: searchValue)
                                }
                            })
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
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if searchValue != "" {
                            searchTag(searchWord: searchValue)
                        }
                        
                    }//IconView
                }//HStack - 검색
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 3) {
                        ForEach(images, id: \.self) { single_image in
                            AsyncImage(url: URL(string: single_image.image_name)) { phase in
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
                                            //viewModel.selectImage(imageUrl: single_image.image_name, imageId: single_image.id)
                                            appState.selectImage(imageUrl: single_image.image_name, imageId: single_image.id)
                                            
                                            selectedImage = single_image.image_name
                                            selectedImageId = single_image.id
                                            
                                            
                                            appState.showImageViewer = true
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
            .sheet(isPresented: $showImageViewer) {
                if let selectedImage = appState.selectedImage, let selectedImageId = appState.selectedImageId {
                    ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
                } else {
                    Text("Loading...")
                }
            }
            .onReceive(appState.$selectedImage) { _ in
                if appState.selectedImage != nil {
                    showImageViewer = true
                }
            }
            //------------------------
            
            .frame(width: geo.size.width)
        }// geo
        
        
    }
    
    func searchTag(searchWord: String) {
        guard let url = URL(string: VarCollectionFile.tagsSearchURL) else {
            print("Invalid URL")
            return
        }
        
        let body: [String: String] = ["search_word": searchWord]
        let request = URLRequest.post(url: url, body: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode([SearchSingleImage].self, from: data) {
                        DispatchQueue.main.async {
                            self.images = decodedResponse
                        }
                    }
                } else if let error = error {
                    VarCollectionFile.myPrint(title: "SearchPageView", content: error)
                }
                
            } else {
                print("Failed to send text to server")
            }
        }.resume()
        
    }
}


class SearchSingleImage: Identifiable, Decodable, Hashable {
    let id: String
    var image_name: String
    
    init(id: String, image_name: String) {
        self.id = id
        self.image_name = image_name
    }
    
    // Hashable 프로토콜을 준수하기 위해 hash(into:) 메서드를 추가합니다.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable 프로토콜을 준수하기 위해 == 연산자를 구현합니다.
    static func == (lhs: SearchSingleImage, rhs: SearchSingleImage) -> Bool {
        return lhs.id == rhs.id && lhs.image_name == rhs.image_name
    }
}



struct SearchPageView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPageView()
    }
}
