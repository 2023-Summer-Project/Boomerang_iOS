//
//  WritePostView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/21.
//

import SwiftUI

struct WritePostView: View {
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var authentifation: Authentication
    @State private var title: String = ""
    @State private var price: String = ""
    @State private var content: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showAlert: Bool = false
    @Binding var showWritePost: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {}, label: { Text("취소") })
                    Spacer()
                    Text("새로운 게시물 작성")
                    Spacer()
                    Button(action: {
                        if price.isEmpty || selectedImages.isEmpty {
                            showAlert = true
                        } else {
                            fireStoreViewModel.uploadProduct(images: selectedImages, POST_CONTENT: content, POST_TITLE: title, PRICE: Int(price)!, OWNER_ID: authentifation.currentUser!.uid)
                            showWritePost = false
                        }
                    }, label: { Text("등록") })
                }
                
                Divider()
                
                TitleView(title: $title)
                
                PriceView(price: $price)
                
                ContentView(content: $content)
                
                InfoView()
                
                SelectImageView(selectedImages: $selectedImages)
            }
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("사진 또는 가격을 입력해 주세요."))
        })
    }
}

struct WritePostView_Previews: PreviewProvider {
    static var previews: some View {
        WritePostView(showWritePost: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
    }
}
