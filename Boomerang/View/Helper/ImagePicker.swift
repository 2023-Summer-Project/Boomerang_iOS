//
//  ImagePicker.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/28.
//

import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) private var presentationMode    //An indication whether a view is currently presented by another view.
    var sourceType: UIImagePickerController.SourceType
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var target: ImagePickerView
        
        init(_ target: ImagePickerView) {
            self.target = target
        }
        
        //this method will be called when an image is selected
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                target.selectedImages.append(image)
            }
            
            target.presentationMode.wrappedValue.dismiss()
        }
    }
    
    //called when the ImagePicker is initialized
    // Return an instance of UIImagePickerController from UIKit
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    //called when the state of the app changes(optional)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

//extension UIImage {
//    func crop() -> UIImage {
//        guard let cgImage = self.cgImage else {
//            return self
//        }
//
//        let sourceSize = self.size
//        let sideLength = min(sourceSize.width, sourceSize.height)
//        let xOffset = (sourceSize.width - 2100) / 2.0
//        let yOffset = (sourceSize.height - 2100) / 2.0
//        let cropRect = CGRect(x: xOffset, y: yOffset, width: 2100, height: 2100)
//
//        guard let croppedCgImage = cgImage.cropping(to: cropRect) else {
//            return self
//        }
//
//        return UIImage(cgImage: croppedCgImage, scale: self.scale, orientation: self.imageOrientation)
//    }
//}
