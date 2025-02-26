//
//  ImageEditorVM.swift
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

import UIKit
import PhotosUI
import SwiftUI

class ImageEditorVM: ObservableObject {
    @Published var imageItem: PhotosPickerItem?
    @Published var imagePick: UIImage?
    @Published var originalImage: UIImage?
    @Published var temperatureValue: Int32 = 0
    @Published var errorJpegOnly: Bool = false

    func loadImage() {
        guard let imageItem = imageItem else { return }
        errorJpegOnly = false
        Task {
            if let data = try? await imageItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data),
               let identifier = imageItem.supportedContentTypes.first,
               identifier == UTType.jpeg {
                DispatchQueue.main.async {  [weak self] in
                    guard let `self` = self else { return }
                    self.originalImage = uiImage
                    self.imagePick = uiImage
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.errorJpegOnly = true
                    self.imageItem = nil 
                    self.imagePick = nil
                }
            }
        }
    }

    func adjustTemperature() {
        guard let originalImage = originalImage else { return }
        let adjustedImage = OpenCVWrapper.adjustTemperature(originalImage, temperature: temperatureValue)
        self.imagePick = adjustedImage
    }

    func resetImage() {
        temperatureValue = 0
        loadImage()
    }

    func clearImage() {
        imageItem = nil
        imagePick = nil
        originalImage = nil
        temperatureValue = 0
    }
}
