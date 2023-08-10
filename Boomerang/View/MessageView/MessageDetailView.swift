//
//  MessageDetailVie.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/02.
//

import SwiftUI
import FirebaseAuth

struct MessageDetailView: View {
    @StateObject var messagesViewModle: MessagesViewModel
    @State var messageInput: String = ""
    @Binding var showTabbar: Bool
    
    var chatId: String
    var chatInfo: Chat
    
    var sortedMessages: [Message] {        
        messagesViewModle.messages[chatId, default: []]
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                ForEach(sortedMessages, id: \.timestamp) { message in
                    if message.user_uid == Auth.auth().currentUser?.uid {
                        UserMessageView(message: message)
                            .padding(.trailing, 10)
                    } else {
                        OtherUserMessageView(message: message)
                            .padding(.leading, 10)
                    }
                }
            }
            
            MessageInputView(messageInput: $messageInput, chatId: chatId)
                .environmentObject(messagesViewModle)
                .padding()
        }
        .navigationTitle(chatInfo.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showTabbar = false
        }
        .onDisappear {
            showTabbar = true
        }
    }
}

struct MessageDetailVie_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(messagesViewModle: MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"),showTabbar: .constant(false),  chatId: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023", chatInfo: Chat(id: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023", last_message: "마지막 메시지", last_timestamp: "", title: "메세지 타이틀"))
    }
}
