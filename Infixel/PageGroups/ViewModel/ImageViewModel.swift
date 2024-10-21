//
//  ImageViewModel.swift
//  Infixel
//
//  Created by 차상진 on 6/22/24.
//

import Foundation
//import Combine
import SwiftUI

class ImageViewModel: ObservableObject {
    @Published var selectedImage: String? = nil
    @Published var selectedImageId: String? = nil
    
    func selectImage(imageUrl: String, imageId: String) {
        selectedImage = imageUrl
        selectedImageId = imageId
    }
}
