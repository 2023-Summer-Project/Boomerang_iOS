//
//  SeclectImageView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/26.
//

import SwiftUI
import PhotosUI

struct SelectImageView: View {
    @State private var selectedImage: PhotosPickerItem?
    @Binding var selectedImageData: Data?
    
    var body: some View {
        HStack {
            if let image = selectedImageData, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                
            } else {
                Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            PhotosPicker(selection: $selectedImage, matching: .images) { Text("사진 선택") }
                .onChange(of: selectedImage) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView(selectedImageData: .constant(nil))
    }
}
