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
    @State var messageInput: String = ""
    @Binding var selectedProduct: Product?
    @Binding var chatId: String?
    
    var chatTitle: String
    
    var body: some View {
        HStack {
            TextField("", text: $messageInput)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                if let chatId = messagesViewModel.chatId {
                    let now = Int(trunc(Date().timeIntervalSince1970 * 1000))
                    
                    messagesViewModel.uploadMessageToExsistingChat(message: messageInput, title: chatTitle, timestamp: now)
                    
                    chatViewModel.updateLocalChatInfo(messageInput, timestamp: now, for: chatId)
                } else {                    
                    self.chatId = messagesViewModel.uploadMessageToNewChat(from: selectedProduct!.OWNER_ID, for: selectedProduct!.id, productTitle: selectedProduct!.PRODUCT_NAME, message: messageInput)
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
        MessageInputView(messageInput: "", selectedProduct: .constant(nil), chatId: .constant("bad51940-15ec-4ea3-ac2f-9b79bf9aa023"), chatTitle: "제목은 여기에 표시됩니다.")
            .environmentObject(MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"))
    }
}
