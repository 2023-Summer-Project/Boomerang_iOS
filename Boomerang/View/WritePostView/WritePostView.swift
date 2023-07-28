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
    @State private var selectedImageData: Data?
    @Binding var showWritePostView: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                TitleView(title: $title)
                
                PriceView(price: $price)
                
                ContentView(content: $content)
                
                SelectImageView(selectedImageData: $selectedImageData)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    fireStoreViewModel.addProduct(imageData: selectedImageData!, POST_CONTENT: content, POST_TITLE: title, PRICE: Int(price)!, OWNER_ID: authentifation.currentUser!.uid)
                    showWritePostView = false
                }, label: { Text("등록하기") })
            })
        }
    }
}

struct WritePostView_Previews: PreviewProvider {
    static var previews: some View {
        WritePostView(showWritePostView: .constant(true))
    }
}
