//
//  MessageInputView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/03.
//

import SwiftUI

struct MessageInputView: View {
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @State private var messageInput: String = ""
    @Binding var selectedProduct: Product?
    
    var chatTitle: String
    
    var body: some View {
        HStack {
            TextField("", text: $messageInput)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                if messagesViewModel.chatId != nil {
                    messagesViewModel.uploadMessageToExsistingChat(message: messageInput, title: chatTitle, timestamp: Int(trunc(Date().timeIntervalSince1970 * 1000)), userName: userInfoViewModel.userInfo?.userName ?? "No Name")
                } else {                    
                    messagesViewModel.uploadMessageToNewChat(from: selectedProduct!.OWNER_ID, for: selectedProduct!.id, productTitle: selectedProduct!.PRODUCT_NAME, message: messageInput, userName: userInfoViewModel.userInfo?.userName ?? "No Name")
                }
                
                messageInput = ""
            }, label: {
                Image(systemName: "arrow.forward.circle.fill")
                    .font(.title2)
            })
            .disabled(messageInput == "")
        }
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(selectedProduct: .constant(nil), chatTitle: "제목은 여기에 표시됩니다.")
            .environmentObject(MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"))
            .environmentObject(UserInfoViewModel())
    }
}
