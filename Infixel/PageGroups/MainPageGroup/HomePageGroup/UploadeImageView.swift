import UIKit
import SwiftUI
import PhotosUI


struct UploadImageView: View {
    @StateObject private var viewModel = UploadImageViewModel()
    @State private var isPickerPresented = false
    
    //@State var tagText:String = ""
    //@State var tags:[String] = []
    
    @EnvironmentObject var appState:AppState
    
    var body: some View {
        
        ZStack {
            
            VStack {
                HStack {
                    Spacer()
                    UploadImagePlusView()
                        .contentTransition(.symbolEffect)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        .environmentObject(appState)
                        .onTapGesture {
                            withAnimation {
                                appState.uploadPlusBtnClicked.toggle()
                            }
                        }
                }//HStak
                Spacer()
            }
            
            
            
            
            
            
        
        
        
        VStack(spacing: 0) {
            
            
            Text("이미지 업로드")
                .fontWeight(.bold)
                .font(Font.custom("Bungee-Regular", size: 20))
                .padding(.bottom, 20)
            
            /// 이미지 선택하는 부분
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                    .padding()
                    .frame(height: 200)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hexString: "e8e8e8"))
                            .frame(width: 200, height: 200)
                            .background(Color(UIColor.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.clear, lineWidth: 0) // 필요시 경계선 설정
                            .frame(width: 200, height: 200)
                        //.background(Color(UIColor.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Text("Select an Image")
                    }
                    
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                    
                }
                
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("게시글 작성")
                        .fontDesign(.rounded)
                    Spacer()
                }
                
                TextField("문구를 작성해주세요.", text: $viewModel.description)
                    .padding(5)
                    .textFieldStyle(PlainTextFieldStyle())
                
                Divider()
                
            }
            .padding(.top, 5)
            .padding()
            
            ///Tag 선택 부분
            VStack(spacing: 0) {
                
                HStack {
                    
                    Text("태그 작성")
                    Spacer()
                }
                
                TextField("띄어쓰기로 태그를 구분합니다.", text: $viewModel.tagText)
                    .padding(5)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.tagText) { newValue in
                        viewModel.checkForSpace(newValue)
                    }
                
                Divider()
            }
            .padding(.top, 15)
            .padding()
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        HStack(spacing: 2) {
                            Text("#"+tag)
                            
                            Image(systemName: "xmark.circle.fill")   // << base !!
                                .resizable()
                                .frame(width: 15, height: 15)
                            
                        }
                            .padding()
                            .foregroundColor(.blue)
                            .onTapGesture {
                                viewModel.removeTag(tag)
                            }
                        
                    }
                }
            }
            .frame(height: 30)
            
            Spacer()
                .frame(height: 100)
            
            ///업로드 버튼
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        if viewModel.selectedImage != nil {
                            viewModel.uploadImage(appState)
                        }
                    }) {
                        if viewModel.uploadStatus == "" {
                            Text("Upload")
                        } else {
                            Text(viewModel.uploadStatus)
                        }
                    }
                    .disabled(viewModel.selectedImage == nil)
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
            
            
            
            
        }//VStack
        .padding(.top, 40)
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
    }
        
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}





class UploadImageViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var uploadStatus: String = ""
    //@Published var userId: String = "userid1"
    @Published var description: String = ""
    @Published var tags: [String] = []
    @Published var tagText = ""
    
    
    
    
    private var imageUploader = ImageUploader()
    
    func removeTag(_ tag: String) {
            if let index = tags.firstIndex(of: tag) {
                tags.remove(at: index)
            }
        }
    
    
    func checkForSpace(_ text: String) {
            if let lastCharacter = text.last, lastCharacter == " " {
                let components = text.split(separator: " ")
                tags.append(String(components[0]))
                tagText = String(text.dropFirst(components[0].count + 1))
            }
        }
    
    func uploadImage(_ appState: AppState) {
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        imageUploader.uploadImage(selectedImage, userId: UserDefaults.standard.string(forKey: "user_id")!, description: description, tags: tags, to: VarCollectionFile.imageUploadURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.uploadStatus = response.message
                    withAnimation {
                        appState.uploadPlusBtnClicked = false
                    }
                    
                case .failure(let error):
                    self?.uploadStatus = "업로드 실패"
                    appState.uploadPlusBtnClicked = false
                }
            }
        }
    }
}




class ImageUploader {
    func uploadImage(_ image: UIImage, userId: String, description: String, tags:[String], to urlString: String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
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
        data.append(image.jpegData(compressionQuality: 0.8)!)
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(userId)\r\n".data(using: .utf8)!)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(description)\r\n".data(using: .utf8)!)
        
        for tag in tags {
               data.append("--\(boundary)\r\n".data(using: .utf8)!)
               data.append("Content-Disposition: form-data; name=\"tags\"\r\n\r\n".data(using: .utf8)!)
               data.append("\(tag)\r\n".data(using: .utf8)!)
           }
        
        
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








struct UploadResponse: Codable {
    let message: String
    let filePath: String
//    let userId: String
//    let description: String
}











