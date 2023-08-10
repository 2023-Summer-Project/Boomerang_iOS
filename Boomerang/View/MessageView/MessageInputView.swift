//
//  MessageInputView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/03.
//

import SwiftUI

struct MessageInputView: View {
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @Binding var messageInput: String
    
    var chatId: String
    
    var body: some View {
        HStack {
            TextField("", text: $messageInput)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                messagesViewModel.uploadNewMessage(message: messageInput)
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
        MessageInputView(messageInput: .constant(""), chatId: "")
            .environmentObject(MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"))
    }
}
