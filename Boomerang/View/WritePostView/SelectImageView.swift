//
//  SeclectImageView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/26.
//

import SwiftUI

struct SelectImageView: View {
    @State private var showActionSheet: Bool = false
    @State private var onCamera: Bool = false
    @State private var onPhotoLibrary: Bool = false
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        HStack {
            HStack {
                ForEach(0..<selectedImages.count, id: \.self) { index in
                    ZStack {
                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)

                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
                            .offset(x: 30, y: -30)
                            .onTapGesture {
                                selectedImages.remove(at: index)
                            }
                    }
                    .padding(.trailing, 5)
                }
            }
            
            if selectedImages.count < 5 {
                Button(action: { self.showActionSheet = true }, label: {
                    Image(systemName: "camera.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding([.leading, .trailing], -5)
                        .foregroundColor(.black)
                })
                .buttonStyle(.bordered)
                .frame(width: 60, height: 60)
            }
            
            Spacer()
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("이미지 선택하기"),
                message: nil,
                buttons: [
                    .default(
                        Text("카메라"),
                        action: { onCamera = true }
                    ),
                    .default(
                        Text("사진 앨범"),
                        action: { onPhotoLibrary = true }
                    ),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $onPhotoLibrary, content: {
            ImagePickerView(selectedImages: $selectedImages, sourceType: .photoLibrary)
        })
        .fullScreenCover(isPresented: $onCamera, content: {
            ImagePickerView(selectedImages: $selectedImages, sourceType: .camera)
        })
    }
}

struct SelectImageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageView(selectedImages: .constant([UIImage()]))
    }
}
