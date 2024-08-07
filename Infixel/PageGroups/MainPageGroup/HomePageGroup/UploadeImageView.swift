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
            ScrollView {
                Text("새 이미지")
                    .fontWeight(.bold)
                    .font(Font.custom("Bungee-Regular", size: 25))
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
    //--@-이미지선택하는부분------------------------------------------------------------------------------
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
                            isPickerPresented.toggle()
                        }
                        .padding(.bottom, 30)
    //                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                } else {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hexString: "F0F0F0"))
                                .strokeBorder(Color(hexString: "4657F3"), lineWidth: 3) // 필요시 경계선 설정
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(height: 400)
                            
                            Text("이미지 선택")
                                .foregroundColor(Color(hexString: "4657F3"))
                        }
                        .onTapGesture {
                            isPickerPresented.toggle()
                        }
                    }
                    .padding(.bottom, 30)
                }
    //--@--------------------------------------------------------------------------------------------
                
                VStack(spacing: 0) {
                    TextField("문구를 작성해주세요.", text: $viewModel.description)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.bottom, 7)
                    
                    Divider()
                        .background(Color(hexString: "4657F3"))
                    
                }//vstack
                .padding(.bottom, 60)
                
                ///Tag 선택 부분
                VStack(spacing: 0) {
                    TextField("띄어쓰기로 태그를 구분합니다.", text: $viewModel.tagText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.bottom, 7)
                        .onChange(of: viewModel.tagText) { newValue in
                            viewModel.checkForSpace(newValue)
                        }
                    
                    Divider()
                        .background(Color(hexString: "4657F3"))
                }//vtack
            
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
                .frame(height: 50)
                .padding(.bottom, 30)
                
                Spacer()
                
                        Button(action: {
                            if viewModel.selectedImage != nil {
                                viewModel.uploadImage(appState)
                            }
                        }) {
                            if viewModel.uploadStatus == "" {
                                HStack {
                                    Text("Upload")
                                }
                                

                            } else {
                                HStack {
                                    Text(viewModel.uploadStatus)
                                }
                            }
                        }
                        .frame(width: 100, height: 45)
                        .disabled(viewModel.selectedImage == nil)
                        .padding([.leading, .trailing], 110)
                        .background(viewModel.selectedImage != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                
                
                
            }//VStack
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
            
            //--@-페이지_닫기_버튼-------------------------------------------------------------------------------------------
            VStack {
                HStack {
                    Spacer()
                    UploadImagePlusView()
                        .contentTransition(.symbolEffect)
//                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        .environmentObject(appState)
                        .onTapGesture {
                            withAnimation {
                                appState.uploadPlusBtnClicked.toggle()
                            }
                        }
                }//HStak
                Spacer()
            }
            //-@--------------------------------------------------------------------------------------------------------

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



#Preview {
    UploadImageView()
        .environmentObject(AppState())
}







