//
//  MessageDetailVie.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/02.
//

import SwiftUI
import FirebaseAuth

struct MessageDetailView: View {
    @EnvironmentObject var realtimeDatabaseViewModel: RealtimeDatabaseViewModel
    @State var messageInput: String = ""
    
    var chatId: String
    var chat: Chat
    
    var sortedMessages: [Message] {        
        realtimeDatabaseViewModel.messages[chatId, default: []]
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    init(_ chat: Chat, chatId: String) {
        self.chat = chat
        self.chatId = chatId
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(sortedMessages, id: \.timestamp) { message in
                    if message.user_uid == Auth.auth().currentUser?.uid {
                        UserMessageView(message: message)
                    } else {
                        OtherUserMessageView(message: message)
                    }
                }
            }
            
            MessageInputView(messageInput: $messageInput, chatId: chatId)
                .environmentObject(realtimeDatabaseViewModel)
        }
        .padding()
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageDetailVie_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(Chat(id: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023", last_message: "마지막 메시지", last_timestamp: "", title: "메세지 타이틀"), chatId: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023")
            .environmentObject(RealtimeDatabaseViewModel())
    }
}
