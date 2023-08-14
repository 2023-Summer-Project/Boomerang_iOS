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
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State var chatId: String?
    @Binding var showTabbar: Bool
    @Binding var selectedProduct: Product?
    var messageTitle: String
    
    var sortedMessages: [Message] {        
        messagesViewModle.messages[chatId ?? "", default: []]
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
            
            MessageInputView(selectedProduct: $selectedProduct, chatId: $chatId, chatTitle: messageTitle)
                .environmentObject(messagesViewModle)
                .padding()
        }
        .navigationTitle(messageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageDetailVie_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(messagesViewModle: MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"),chatId: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023", showTabbar: .constant(false), selectedProduct: .constant(nil), messageTitle: "메시지 타이틀")
    }
}
