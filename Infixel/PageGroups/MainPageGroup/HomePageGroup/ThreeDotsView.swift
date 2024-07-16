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
    
    
    @State var isDownloadTapped = false
    @State var isReportTapped = false
    
    init(slideImage: Binding<SlideImage>) {
        _viewModel = StateObject(wrappedValue: ThreeDotsViewModel(slideImage: slideImage.wrappedValue))
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
                //.padding(.leading)
                .padding(7)
                .background(isDownloadTapped ? .black.opacity(0.4) : .clear)
//                .background(isDownloadTapped ? .ultraThinMaterial : .clear)
                .cornerRadius(5)
                .onTapGesture {
                    withAnimation {
                        isDownloadTapped = true // 사용자가 탭하면 isTapped를 true로 설정
                        viewModel.imageDownload(from: "https://i.pinimg.com/originals/db/9f/49/db9f4993cfd5f36c1afb940c8071fc07.jpg")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                           isDownloadTapped = false // 0.5초 후에 isTapped를 false로 설정하여 원래 색으로 돌아감
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
//                .padding(.leading)
                .onTapGesture {
                    withAnimation {
                        isReportTapped = true // 사용자가 탭하면 isTapped를 true로 설정
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            isReportTapped = false // 0.5초 후에 isTapped를 false로 설정하여 원래 색으로 돌아감
                        }
                    }
                }
                
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
                   
               } else {
                   appState.threeDotsOffset = value.translation.height + 300
               }
               
           }
            .onEnded { value in
                if appState.imageViewerOrNot {
                    
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

class ThreeDotsViewModel: ObservableObject {
    @Published var slideImage: SlideImage
    @EnvironmentObject var appState: AppState
    @Published var downloadImage: UIImage?
    
    init(slideImage: SlideImage) {
        self.slideImage = slideImage
    }
    
    
    func imageDownload(from url:String) {
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
        ThreeDotsView(slideImage: .constant(SlideImage()))
    }
    
}
