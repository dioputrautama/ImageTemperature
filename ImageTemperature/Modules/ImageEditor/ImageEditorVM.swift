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
    @Published var temperatureValue: Int32 = 0

    func loadImage() {
        guard let imageItem = imageItem else { return }
        Task {
            if let data = try? await imageItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imagePick = uiImage
                }
            } else {
                print("Failed to load image")
            }
        }
    }

    func adjustTemperature() {
        guard let image = imagePick else { return }
        Task {
            let adjustedImage = OpenCVWrapper.adjustTemperature(image, temperature: temperatureValue)
            DispatchQueue.main.async {
                self.imagePick = adjustedImage
            }
        }
    }

    func resetImage() {
        temperatureValue = 0
        loadImage()
    }

    func clearImage() {
        imageItem = nil
        imagePick = nil
        temperatureValue = 0
    }
}
