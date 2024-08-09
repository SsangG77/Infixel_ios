//
//  ThreeDotsView.swift
//  Infixel
//
//  Created by 차상진 on 7/15/24.
//

import SwiftUI
import Combine
import Photos


//info button view에서 점세개 버튼을 눌렀을때 나타나는 뷰
struct ThreeDotsView: View {
    
    @StateObject private var viewModel: ThreeDotsViewModel
       
    @EnvironmentObject var appState: AppState
    
    @Binding var slideImage:SlideImage
    @State var isDownloadTapped = false ///버튼 눌렀을때 효과용 변수
    @State var isReportTapped = false
    
    init(slideImage: Binding<SlideImage>) {
        self._slideImage = slideImage
        self._viewModel = StateObject(wrappedValue: ThreeDotsViewModel(slideImage: slideImage))
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                VStack {
                    Rectangle() //상단 핸들 모양
                        .frame(width: 40.0, height: 10)
                        .foregroundColor(Color(hexString: "F4F2F2"))
                        .cornerRadius(20)
                        .padding([.top, .bottom], 20)
                        .gesture(
                            DragGesture()
                           .onChanged { value in
                               if appState.imageViewerOrNot {
                                   appState.threedotsOffset_imageViewer = value.translation.height + 200
                               } else {
                                   appState.threeDotsOffset = value.translation.height + 200
                               }
                               
                           }
                            .onEnded { value in
                                if appState.imageViewerOrNot {
                                    if appState.threedotsOffset_imageViewer > 250 {
                                        appState.threedotsOffset_imageViewer = 1000
                                        appState.threedotsOpen_imageViewer = false
                                    } else if appState.threedotsOffset_imageViewer < 270 {
                                        appState.threedotsOffset_imageViewer = 200
                                        appState.threedotsOpen_imageViewer = true
                                    }
                                } else {
                                    if appState.threeDotsOffset > 250 {
                                        appState.threeDotsOffset = 1000
                                        appState.threeDotsOpen = false
                                    } else if appState.threeDotsOffset < 270 {
                                        appState.threeDotsOffset = 200
                                        appState.threeDotsOpen = true
                                    }
                                }
                            }//onEnded
                       )//gesture
                }//VSttack
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .background(.white)
                
                
                VStack {
                    
                    HStack {
                        Text("이미지 다운로드")
                            .padding(3)
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                        Spacer()
                    }
                    .padding(7)
                    .background(isDownloadTapped ? .black.opacity(0.4) : .clear)
                    .cornerRadius(5)
                    .onTapGesture {
                        withAnimation {
                            isDownloadTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                               isDownloadTapped = false
                                viewModel.imageDownload(from: slideImage.link) {
                                        appState.threeDotsOpen = false
                                        appState.threeDotsOffset = 1000
                                }
                            }
                        }
                    }
                    
                    HStack {
                        
                        Text("이미지 신고")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                        
                        Spacer()
                    }
                    .padding(7)
                    .background(isReportTapped ? .black.opacity(0.4) : .clear)
                    .cornerRadius(5)
                    .onTapGesture {
                        withAnimation {
                            isReportTapped = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                isReportTapped = false
                                viewModel.reportImage(imageId: slideImage.id)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height)
                .padding(7)
                .background(.white)
                
            }//Vstack
            .cornerRadius(40)
            
        }//Geo
        
        
        
        
    }
}


//view model
class ThreeDotsViewModel: ObservableObject {
    @Published var slideImage: SlideImage
    @Published var downloadImage: UIImage?
    @Published var report_res: Bool = false
    
//    var downloadComplete: (() -> Void)?
    
    init(slideImage: Binding<SlideImage>) {
        self._slideImage = Published(initialValue: slideImage.wrappedValue)
    }
    
    
    func imageDownload(from url:String, downloadComplete: @escaping (()-> Void)) {
        print(url)
        guard let imageURL = URL(string: url) else {
            
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Download error: \(error.localizedDescription)")
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid data or unable to create image")
                    return
                }

                DispatchQueue.main.async {
                    self.downloadImage = image
                    self.saveImageToAlbum(image)
                    downloadComplete()
                }
            }.resume()
    }
    
    
    func saveImageToAlbum(_ image: UIImage) {

        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                //return false
                
                
            } else {
                print("Permission not granted to access photo library")
            }
        }
    }
    
    func reportImage(imageId: String) {
        print("report image", imageId)
        
        
        guard let url = URL(string: VarCollectionFile.reportImageURL) else {
            return
        }
        
        let params: [String: Any] = [
            "image_id" : imageId,
            "user_id" : String(UserDefaults.standard.string(forKey: "user_id")!)
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                print("Failed to encode JSON")
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let report_data = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(report_data)
                    
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error : \(error)")
                }
            }
        }.resume()
        
        
        
    }//reportImage
    
}






#Preview {
    ZStack {
        Color(.black).edgesIgnoringSafeArea(.all)
        ThreeDotsView(slideImage: .constant(SlideImage()))
    }
    
}
