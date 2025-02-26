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
    @StateObject private var viewModel = ImageEditorVM()

    var body: some View {
        VStack {

            HStack(spacing: 30) {
                Text("Image Temperature")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: { viewModel.resetImage() }) {
                    Image(systemName: "arrow.uturn.backward")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Button(action: { viewModel.clearImage() }) {
                    Image(systemName: "trash")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.all, 16)

            Spacer()

            VStack(alignment: .center) {
                if let imagePick = viewModel.imagePick {
                    Image(uiImage: imagePick)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 70, height: 60)
                        PhotosPicker("Select Image", selection: $viewModel.imageItem, matching: .images)
                    }
                }
            }

            Spacer()

            VStack(alignment: .leading) {
                HStack {
                    Text("Temperature")
                        .font(.headline)
                        .foregroundColor(viewModel.temperatureValue > 0 ? .red : (viewModel.temperatureValue < 0 ? .blue : .gray))
                    Spacer()
                    Text("\(viewModel.temperatureValue)°")
                        .font(.headline)
                        .foregroundColor(viewModel.temperatureValue > 0 ? .red : (viewModel.temperatureValue < 0 ? .blue : .gray))
                }

                Slider(value: Binding(
                    get: { Double(viewModel.temperatureValue) },
                    set: { viewModel.temperatureValue = Int32(Int($0)) }
                ), in: -100...100, step: 1)
            }
            .padding()
            .padding(.bottom, 20)
            .background(Color.gray.opacity(0.2))
            .clipShape(
                RoundedCornerShape(radius: 16, corners: [.topLeft, .topRight])
            )
        }
        .onChange(of: viewModel.imageItem) { _ in
            viewModel.loadImage()
        }
        .onChange(of: viewModel.temperatureValue) { _ in
            viewModel.adjustTemperature()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
