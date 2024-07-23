//
//  SavePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI



class SavePageViewModel: ObservableObject {
    
    @Published var albumPlusClicked = false
    @Published var imageClicked = false
    @Published var albumIds = []
    @Published var imageId:String? = nil
    @Published var imageURL: String? = nil
    @Published var isPickerPresented = false
    @Published var selectedImage: UIImage? = nil
    @Published var albumName:String = ""
    @Published var uploadStatus: String = ""
    @Published var uploadBtnClicked = false
    
    
    private var retryCount: [String: Int] = [:]
    
    
    func calculateScale(geometry: GeometryProxy) -> CGFloat {
        let midX = geometry.frame(in: .global).midX
        let screenWidth = UIScreen.main.bounds.width
        let threshold: CGFloat = screenWidth / 2
        
        // 중앙에서의 거리 계산
        let distance = abs(midX - screenWidth / 2)
        let scale = max(0.7, 1 - (distance / threshold) * 0.5)
        
        return scale
    }
    
    
    func retryImageLoading(url: String) {
        let maxRetries = 3
        let delay = 1.0
        
        if retryCount[url, default: 0] < maxRetries {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.retryCount[url, default: 0] += 1
                self.objectWillChange.send() // Trigger view update to retry loading
            }
        }
    }
    
    
    
    func uploadAlbum() {
        
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        
        self.uploadImage(selectedImage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.uploadStatus = response.message
                    withAnimation {
                        self!.albumPlusClicked = false
                    }
                    
                case .failure(let error):
                    self?.uploadStatus = "업로드 실패"
                    self!.albumPlusClicked = false
                }
            }
        }
        
    }
    
    func uploadImage(_ selectedImage: UIImage, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        let userId = UserDefaults.standard.string(forKey: "user_id")!
        
        guard let url = URL(string: VarCollectionFile.addAlbumURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(selectedImage.jpegData(compressionQuality: 0.8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(userId)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"album_name\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(albumName)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let responseData = responseData else {
                completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: responseData)
                completion(.success(uploadResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
        
    }
    
    
    
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageView: View {
    
    @StateObject private var viewModel = SavePageViewModel()
    @StateObject private var addAlbumViewModel = AddAlbumViewModel()
    
    var body: some View {
        VStack {
            SavePageViewHeader()
                .environmentObject(viewModel)
            
            ScrollView {
                ForEach($addAlbumViewModel.albumList) { album in
                    SavePageAlbumView()
                        .environmentObject(viewModel)
                        .environmentObject(SavePageAlbumViewModel(albumId: album.id, albumName: album.album_name.wrappedValue))
                }
            }
            .contentMargins(.bottom, 40)
            
            
            Spacer()
        }
        .onAppear {
            addAlbumViewModel.getAlbums()
        }
        .sheet(isPresented: $viewModel.albumPlusClicked) {
            SavePageAddAlbumView()
                .environmentObject(viewModel)
        }
        
    }
    
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAddAlbumView: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    var body: some View {
        VStack{
            VStack(spacing: 3) {
                HStack {
                    Text("Add Album")
                        .font(Font.custom("Bungee-Regular", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hexString: "4657F3"))
                    
                    Spacer()
                    
                }
                
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .foregroundColor(Color(hexString: "4657F3"))
                    .frame(height: 3)
                
            }
            .padding(30)
            
            VStack {
                /// 이미지 선택하는 부분
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .onTapGesture {
                            viewModel.isPickerPresented.toggle()
                        }
                        .padding()
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                } else {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hexString: "ABB2F2"))
                                .frame(width: 200, height: 200)
                                .background(Color(UIColor.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.clear, lineWidth: 0) // 필요시 경계선 설정
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text("Select an Image")
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.isPickerPresented.toggle()
                        }
                    }
                }
            }
            
            VStack(spacing: 5) {
                HStack {
                    Text("Album name")
                        .font(Font.custom("Bungee-Regular", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hexString: "4657F3"))
                    Spacer()
                }
                
                TextField("앨범 이름을 작성해주세요.", text: $viewModel.albumName)
                    .padding(5)
                    .textFieldStyle(PlainTextFieldStyle())
                
                Divider()
                
            }
            .padding(.top, 5)
            .padding()
            
            Spacer()
                .frame(height: 200)
            
            ///업로드 버튼
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        if viewModel.selectedImage != nil && viewModel.albumName != "" {
                            viewModel.uploadAlbum()
                        }
                    }) {
                        if viewModel.uploadStatus == "" {
                            Text("Add")
                        } else {
                            Text(viewModel.uploadStatus)
                        }
                    }
                    .disabled(viewModel.selectedImage == nil && viewModel.albumName == "")
                    .padding()
                    .frame(width: geometry.size.width * 0.8) // 버튼 너비를 전체 화면의 80%로 설정
                    .background(viewModel.selectedImage != nil ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding()
                }
                .frame(width: geometry.size.width, height: 100, alignment: .center)
            }
            .edgesIgnoringSafeArea(.all) // 전체 화면을 사용하도록 설정
            
        }
        
        .sheet(isPresented: $viewModel.isPickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        
        
    }
}


//--@SavePageViewHeader-----------------------------------------------------------------------------------------------------------------------
struct SavePageViewHeader: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text("Albums")
                    .font(Font.custom("Bungee-Regular", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hexString: "4657F3"))
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hexString: "4657F3"))
                    .onTapGesture {
                        print("앨범 추가 버튼")
                        viewModel.albumPlusClicked = true
                    }
            }
            
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .foregroundColor(Color(hexString: "4657F3"))
                .frame(height: 3)
            
        }
        .padding()
    }
}


//--@SavePageAlbumViewModel-------------------------------------------------------------------------------------------------------
class SavePageAlbumViewModel: ObservableObject {
    @Published var albumId:String
    @Published var albumName: String
    
    init(albumId: String, albumName: String) {
        self.albumId = albumId
        self.albumName = albumName
    }
    
    
}


//--@SavePageAlbumView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAlbumView: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    @EnvironmentObject var savePageAlbumViewModel: SavePageAlbumViewModel
    
    @StateObject var albumDetailViewModel = AlbumDetailViewModel()
    
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text(savePageAlbumViewModel.albumName)
                    .font(Font.custom("Bungee-Regular", size: 20))
                Spacer()
            }
            .padding(.leading)

            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center) {
                    ForEach(albumDetailViewModel.images) { image_ in
                        GeometryReader { geo in
                                Spacer()
                                AsyncImage(url: URL(string: image_.image_name), transaction: Transaction(animation: .default)) { phase in
                                    switch phase {
                                        
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100, height: 150)
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                                            .clipped()
                                            .cornerRadius(10)
                                            .scaleEffect(viewModel.calculateScale(geometry: geo))
                                            .onTapGesture {
                                                viewModel.imageClicked = true
                                                viewModel.imageId = image_.id
                                                viewModel.imageURL = image_.image_name
                                            }
                
                                    case .failure:
                                        VStack {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                                .scaleEffect(2)
                                        }
                                        .frame(width: 100, height: 150)
                                        .onAppear {
                                            viewModel.retryImageLoading(url: image_.image_name)
                                        }
                                        
                                    @unknown default:
                                        EmptyView()
                                    }//--@switch
                                }//--@AsyncImage
                        }//--@geo
                        .frame(width: 120, height: 170)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 7, y: 5)
                        .containerRelativeFrame(.horizontal, count: 3, spacing: 5)
                        
                    }//--@ForEach
                    
                }//--@LazyHStack
                .scrollTargetLayout()
                .frame(height: 190)
                
            }//--@ScrollView
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 20)
            
            
            Divider()
                .padding()
            
        }
        .onAppear {
            albumDetailViewModel.searchAlbumImage(albumId: savePageAlbumViewModel.albumId)
        }
        .sheet(isPresented: $viewModel.imageClicked) {
//            Text("이미지")
            if let selectedImage = viewModel.imageURL, let selectedImageId = viewModel.imageId {
                ImageViewer(imageUrl: .constant(selectedImage), imageId: .constant(selectedImageId))
            } else {
                Text("Loading...")
            }
            
        }
//        .frame(height: 210)
    }
}



struct SavePageView_Previews: PreviewProvider {
    static var previews: some View {
        SavePageView()
    }
}
