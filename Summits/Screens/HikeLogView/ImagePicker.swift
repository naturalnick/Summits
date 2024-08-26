//
//  ImagePicker.swift
//  Summits
//
//  Created by Nick Schaefer on 1/23/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var images: [Data]
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uploadingPhoto = false
    
    var body: some View {
        VStack {
            ForEach(images, id: \.self) { data in
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
            }
            
            if images.isEmpty {
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    HStack {
                        Label("Add Photo", systemImage: "photo")
                        Spacer()
                        if uploadingPhoto {
                            ProgressView()
                        }
                    }
                }
                .disabled(uploadingPhoto)
            } else {
                Button(role: .destructive, action: {
                    withAnimation {
                        selectedPhoto = nil
                        images = []
                    }
                }, label: {
                    Label("Remove Photo", systemImage: "xmark")
                        .foregroundStyle(.red)
                        .padding(.vertical, 8)
                })
            }
        }
        .task(id: selectedPhoto, {
            uploadingPhoto = true
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                images.append(data)
            }
            uploadingPhoto = false
        })
    }
}
