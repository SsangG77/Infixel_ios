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
    @State var isDownloadTapped = false
    @State var isReportTapped = false
    
    init(slideImage: Binding<SlideImage>) {
        self._slideImage = slideImage
        self._viewModel = StateObject(wrappedValue: ThreeDotsViewModel(slideImage: slideImage))
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                Rectangle() //상단 핸들 모양
                    .frame(width: 40.0, height: 10)
                    .foregroundColor(Color(hexString: "F4F2F2"))
                    .cornerRadius(20)
                    .padding([.top, .bottom], 20)
                    
            }//VStack
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
//                .background(isDownloadTapped ? .ultraThinMaterial : .clear)
                .cornerRadius(5)
                .onTapGesture {
                    withAnimation {
                        isDownloadTapped = true // 사용자가 탭하면 isTapped를 true로 설정
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                           isDownloadTapped = false // 0.5초 후에 isTapped를 false로 설정하여 원래 색으로 돌아감
                            viewModel.imageDownload(
                                from: slideImage.link
                            ) {
                                withAnimation {
                                    print(slideImage.link)
                                    appState.threeDotsOpen = false
                                    appState.threeDotsOffset = 1000
                                }
                            }
                        }
                    }
                }
                
//                HStack {
//                    
//                    Text("이미지 신고")
//                        .fontWeight(.bold)
//                        .font(.system(size: 24))
//                    
//                    Spacer()
//                }
//                .padding(7)
//                .background(isReportTapped ? .black.opacity(0.4) : .clear)
//                .cornerRadius(5)
//                .onTapGesture {
//                    withAnimation {
//                        isReportTapped = true // 사용자가 탭하면 isTapped를 true로 설정
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        withAnimation {
//                            isReportTapped = false // 0.5초 후에 isTapped를 false로 설정하여 원래 색으로 돌아감
//                        }
//                    }
//                }
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .padding(7)
            .background(.white)
        }
        .cornerRadius(20)
        .gesture(
            DragGesture()
           .onChanged { value in
               if appState.imageViewerOrNot {
                   appState.threedotsOffset_imageViewer = value.translation.height + 300
               } else {
                   appState.threeDotsOffset = value.translation.height + 300
               }
               
           }
            .onEnded { value in
                if appState.imageViewerOrNot {
                    if appState.threedotsOffset_imageViewer > 250 {
                        appState.threedotsOffset_imageViewer = 1000
                        appState.threedotsOpen_imageViewer = false
                    } else if appState.threedotsOffset_imageViewer < 270 {
                        appState.threedotsOffset_imageViewer = 300
                        appState.threedotsOpen_imageViewer = true
                    }
                } else {
                    if appState.threeDotsOffset > 250 {
                        appState.threeDotsOffset = 1000
                        appState.threeDotsOpen = false
                    } else if appState.threeDotsOffset < 270 {
                        appState.threeDotsOffset = 300
                        appState.threeDotsOpen = true
                    }
                }
            }
       )
    }
}


//view model
class ThreeDotsViewModel: ObservableObject {
    @Published var slideImage: SlideImage
    @Published var downloadImage: UIImage?
    
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
}






#Preview {
    ZStack {
        Color(.black).edgesIgnoringSafeArea(.all)
        //ThreeDotsView(slideImage: .constant(SlideImage()))
    }
    
}
