import UIKit
import SwiftUI
import PhotosUI


struct UploadImageView: View {
    @StateObject private var viewModel = UploadImageViewModel()
    @State private var isPickerPresented = false
    
    @EnvironmentObject var appState:AppState
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                UploadImagePlusView()
                    .environmentObject(appState)
                    .onTapGesture {
                        withAnimation {
                            appState.uploadPlusBtnClicked.toggle()
                        }
                    }
            }//HStak
            
            Text("이미지 업로드")
                .font(.title)
            
            /// 이미지 선택하는 부분
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
                    .padding()
            } else {
                Text("Select an Image")
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200)
                    .background(Color(UIColor.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        isPickerPresented.toggle()
                    }
            }
            
            ///Description 입력 부분
            TextField("게시글 작성", text: $viewModel.description)
                .padding()
                .frame(height: 200)
            
            
            ///Tag 선택 부분
            
            Spacer()
            
            ///업로드 버튼
            Button(action: {
                if viewModel.selectedImage != nil {
                    viewModel.uploadImage()
                } else {
                    
                }
            }) {
                if viewModel.uploadStatus == "" {
                    Text("Upload")
                    
                } else {
                    Text(viewModel.uploadStatus)
                }
            }
            .disabled(viewModel.selectedImage != nil)
            .padding()
            .background(viewModel.selectedImage != nil ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Text(viewModel.uploadStatus)
                .padding()
                .foregroundColor(.blue)
            
            Spacer()
        }//VStack
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
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
    
    private var imageUploader = ImageUploader()
    
    func uploadImage() {
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        imageUploader.uploadImage(selectedImage, userId: UserDefaults.standard.string(forKey: "user_id")!, description: description, to: VarCollectionFile.imageUploadURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.uploadStatus = response.message
                case .failure(let error):
                    self?.uploadStatus = "Upload Failed: \(error.localizedDescription)"
                }
            }
        }
    }
}




class ImageUploader {
    func uploadImage(_ image: UIImage, userId: String, description: String, to urlString: String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
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












