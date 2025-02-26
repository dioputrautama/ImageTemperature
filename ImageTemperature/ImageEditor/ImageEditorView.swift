//
//  ImageEditorView.swift
//  ImageTemperature
//
//  Created by Dio Putra Utama on 26/02/25.
//

import UIKit
import PhotosUI
import SwiftUI

struct ImageEditorView: View {
    @State private var imageItem: PhotosPickerItem?
    @State private var imagePick: UIImage?
    @State private var temperatureValue: Int32 = 0

    var body: some View {
        VStack {
            HStack(spacing: 30) {
                Text("Image Temperature")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .frame(width: 20, height: 20)
                Image(systemName: "trash")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 20, height: 20)
            }
            .padding(.all, 16)
            Spacer()
            VStack(alignment: .center) {
                if let imagePick {
                    Image(uiImage: imagePick)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 70, height: 60)
                        PhotosPicker("Choose Image", selection: $imageItem, matching: .images)
                    }
                }
            }

            Spacer()
            VStack(alignment: .leading) {
                HStack() {
                    Text("Temperature")
                        .font(.headline)
                        .foregroundColor(temperatureValue > 0 ? .red : (temperatureValue < 0 ? .blue : .gray))
                    Spacer()
                    Text("\(temperatureValue)°")
                        .font(.headline)
                        .foregroundColor(temperatureValue > 0 ? .red : (temperatureValue < 0 ? .blue : .gray))
                }

                Slider(value: Binding(
                    get: { Double(temperatureValue) },
                    set: { temperatureValue = Int32(Int($0)) }
                ), in: -100...100, step: 1)
            }
            .padding()
            .padding(.bottom, 20)
            .background(Color.gray.opacity(0.2))
            .clipShape(
                RoundedCornerShape(radius: 16, corners: [.topLeft, .topRight])
            )
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
        .onChange(of: temperatureValue) { newValue in
                if let image = imagePick {
                    Task {
                        let adjustedImage = OpenCVWrapper.adjustTemperature(image, temperature: newValue)
                        imagePick = adjustedImage // ✅ Apply temperature change automatically
                    }
                }
            }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
