import UIKit
import SwiftUI
import PhotosUI


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

struct UploadImageView: View {
    @StateObject private var viewModel = UploadImageViewModel()
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack {
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("Select an Image")
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 200)
                    .background(Color(UIColor.systemFill))
            }
            
            Button(action: {
                isPickerPresented.toggle()
            }) {
                Text("Upload Image")
            }
            .padding()
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
            
            if viewModel.selectedImage != nil {
                Button(action: {
                    viewModel.uploadImage()
                }) {
                    Text("Upload to Server")
                }
                .padding()
            }
            
            Text(viewModel.uploadStatus)
                .padding()
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct UploadResponse: Codable {
    let message: String
    let filePath: String
    let userId: String
    let description: String
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



class UploadImageViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var uploadStatus: String = ""
    @Published var userId: String = "userid1"
    @Published var description: String = "example_description"
    
    private var imageUploader = ImageUploader()
    
    func uploadImage() {
        guard let selectedImage = selectedImage else {
            uploadStatus = "No image selected"
            return
        }
        
        uploadStatus = "Uploading..."
        imageUploader.uploadImage(selectedImage, userId: userId, description: description, to: VarCollectionFile.imageUploadURL) { [weak self] result in
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

#Preview {
    UploadImageView()
}
