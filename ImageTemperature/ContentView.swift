//
//  ContentView.swift
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

import SwiftUI
import UIKit
import PhotosUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.white)
            ImagePickerView()
        }
        .ignoresSafeArea()
    }
}

struct ImagePickerView: View {
    @State private var imageItem: PhotosPickerItem?
    @State private var imagePick: UIImage?

    var body: some View {
        VStack {
            PhotosPicker("Select Image", selection: $imageItem, matching: .images)

            if let imagePick {
                Image(uiImage: imagePick)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                Text("No Image Selected")
            }

            Button("Adjust Temperature") {
                if let image = imagePick {
                    let adjustedImage = OpenCVWrapper.adjustTemperature(image, temperature: 50)
                    imagePick = adjustedImage
                }
            }
        }
        .onChange(of: imageItem) { _ in
            Task {
                if let data = try? await imageItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    imagePick = uiImage
                } else {
                    print("Failed to load image")
                }
            }
        }
    }
}
