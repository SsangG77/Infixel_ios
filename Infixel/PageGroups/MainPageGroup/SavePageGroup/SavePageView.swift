//
//  SavePageView.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/18.
//

import SwiftUI



class SavePageViewModel: ObservableObject {
    
    @Published var albumPlusClicked     : Bool     = false
    @Published var imageClicked         : Bool     = false
    @Published var uploadBtnClicked     : Bool     = false
    @Published var isPickerPresented    : Bool     = false
    @Published var imageId              : String?  = nil
    @Published var imageURL             : String?  = nil
    @Published var selectedImage        : UIImage? = nil
    @Published var albumName            : String   = ""
    @Published var uploadStatus         : String   = ""
    @Published var albumIds                        = []
    
    
    
    
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
    } //uploadImage
    
    
    func getAlbumInfo(albumId: String) { //프로필 이미지, 앨범 이름을 서버에서 가져와서 변수에 입력
        guard let url = URL(string: VarCollectionFile.getAlbumURL) else {
            return
        }
        
        let request = URLRequest.post(url: url, body: ["album_id" : albumId])
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            URLSession.shared.dataTask(with: request) { data, res, error in
                
            }
        }
        
        
    } //getAlbumInfo
    
    
}



//--@SavePageView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageView: View {
    
    @StateObject private var viewModel = SavePageViewModel()
    @StateObject private var addAlbumViewModel = AddAlbumViewModel()
    
    @State var isActive = false
    @State var albumId = ""
    
    var body: some View {
        
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: AlbumSettingView(id: $albumId),
                    isActive: $isActive,
                    label: {
                        EmptyView()
                    }
                )
                
                VStack {
                    SavePageViewHeader()
                        .environmentObject(viewModel)
                    
                    ScrollView {
                        ForEach($addAlbumViewModel.albumList) { album in
                            SavePageAlbumView(isActive : $isActive, albumId: $albumId)
                                .environmentObject(viewModel)
                                .environmentObject(SavePageAlbumViewModel(albumId: album.id, albumName: album.album_name.wrappedValue, createdAt: album.created_at.wrappedValue))
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
        
        
    }
    
}

//--@AlbumSettingView-----------------------------------------------------------------------------------------------------------------------------
struct AlbumSettingView: View {
    
    @State private var isPickerPresented = false
    
    @Binding var id:String
    @StateObject private var viewModel = SavePageViewModel()
    
    
    var body: some View {
        VStack {
            
            HStack {
                Text("프로필 이미지")
                
                Spacer()
            }
            .padding(.bottom, 5)
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3)
                    )
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                    .padding(.bottom, 30)
                
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hexString: "F0F0F0"))
                            .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3) // 필요시 경계선 설정
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(height: 200)
                        
                        Text("이미지 선택")
                            .foregroundColor(Color(hexString: "4657F3"))
                    }
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                }//VStack
                .padding(.bottom, 30)
            } //else
            
            HStack {
                Text("앨범 이름")
                Spacer()
            }
            
            VStack(spacing: 0) {
                TextField(viewModel.albumName, text: $viewModel.albumName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 7)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
            }//vstack
            
            
            
            
            
        }//VStack
        .padding([.trailing, .leading], 20)
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        
    } //body
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3) // 필요시 경계선 설정
                        )
                        .onTapGesture {
                            viewModel.isPickerPresented.toggle()
                        }
                        .padding(.bottom, 30)
                    
                } else {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hexString: "F0F0F0"))
                                .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3) // 필요시 경계선 설정
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(height: 400)
                            
                            Text("프로필 이미지 선택")
                                .foregroundColor(Color(hexString: "4657F3"))
                        }
                        .onTapGesture {
                            viewModel.isPickerPresented.toggle()
                        }
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            .padding([.leading, .trailing],30)
            
            VStack(spacing: 0) {
                TextField("앨범 이름을 작성해주세요.", text: $viewModel.albumName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 7)
                
                Divider()
                    .background(Color(hexString: "4657F3"))
                
            }//vstack
            .padding(30)
            
            
           
            
            Spacer()
            
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
    @Published var created_at: String
    
    init(albumId: String, albumName: String, createdAt: String) {
        self.albumId = albumId
        self.albumName = albumName
        self.created_at = createdAt
    }
    
    
}


//--@SavePageAlbumView-----------------------------------------------------------------------------------------------------------------------------
struct SavePageAlbumView: View {
    @EnvironmentObject var viewModel: SavePageViewModel
    @EnvironmentObject var savePageAlbumViewModel: SavePageAlbumViewModel
    
    @StateObject var albumDetailViewModel = AlbumDetailViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isShowAlert: Bool = false
    
    @Binding var isActive: Bool
    @Binding var albumId:String
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(savePageAlbumViewModel.albumName)
                        .font(Font.custom("Bungee-Regular", size: 20))
                    
                    Spacer().frame(height: 4)
                    
                    Text(savePageAlbumViewModel.created_at)
                        .opacity(0.5)
                        .fontWeight(.light)
                        .font(.system(size: 13))
                }
                
                
                Spacer()
                Image(systemName: "chevron.right")
                    .fontWeight(.heavy)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        albumId = savePageAlbumViewModel.albumId
                        isActive = true
                    }
                
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
                                        }
                                        .frame(width: 100, height: 150)
                                        .onAppear {
                                            viewModel.retryImageLoading(url: image_.image_name)
                                        }
                                        
                                    @unknown default:
                                        EmptyView()
                                    }//--@switch
                                }//--@AsyncImage
                                .onLongPressGesture(minimumDuration: 0.4) {
                                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                                    generator.impactOccurred()
                                    isShowAlert = true
                                    
                                }
                                .alert(isPresented: $isShowAlert) {
                                    let defaultButton = Alert.Button.default(Text("삭제"))
                                    let cancelButton = Alert.Button.cancel(Text("취소"))
                                    
                                    return Alert(title: Text("이미지 삭제") , message: Text("삭제하시겠습니까?"), primaryButton: defaultButton, secondaryButton: cancelButton)
                                }
                        }//--@geo
                        .frame(width: 120, height: 170)
                        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), radius: 5, x: 4, y: 3)
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
        AlbumSettingView(id: .constant("albumid1") )
    }
}
