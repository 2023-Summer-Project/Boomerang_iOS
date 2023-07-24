//
//  WritePostView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/21.
//

import SwiftUI

struct WritePostView: View {
    @EnvironmentObject var fireStore: FireStore
    @EnvironmentObject var authentifation: Authentication
    @State var title: String = ""
    @State var price: String = ""
    @State var content: String = ""
    @Binding var showWritePostView: Bool
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Text("제목")
                TextField("제목을 입력해 주세요.", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Text("가격")
                HStack {
                    TextField("가격은 얼마 인가요?", text: $price)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Text("원")
                }
                
                Text("물건 소개")
                TextField("물건에 대한 소개를 작성해 주세요.", text: $content, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }

        Group {
            VStack {
                Button(action: {
                    fireStore.addProduct(POST_CONTENT: content, POST_TITLE: title, PRICE: Int(price)!, OWNER_ID: authentifation.currentUser!.uid)
                    showWritePostView = false
                }, label: { Text("물건 등록하기") })

                Spacer()
            }
        }
    }
}

struct WritePostView_Previews: PreviewProvider {
    static var previews: some View {
        WritePostView(showWritePostView: .constant(true))
    }
}
