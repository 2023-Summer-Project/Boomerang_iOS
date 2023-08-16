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
    @Binding var selectedProduct: Product?
    var messageTitle: String
    
    var sortedMessages: [Message] {        
        messagesViewModle.messages[chatId ?? "", default: []]
            .sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("해당 상품을 다시 보고 싶으신가요?")
                    .padding([.leading, .bottom, .top], 10)
                Text("다시 확인하기")
                    .underline()
                Spacer()
            }
            .font(.caption2)
            .background(.gray)
            .cornerRadius(8)
            .padding([.leading, .trailing], 10)
            
            ScrollView {
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
                .environmentObject(chatViewModel)
                .padding([.leading, .bottom, .trailing])
                .padding(.top, 3)
        }
        .navigationTitle(messageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("background"))
    }
}

struct MessageDetailVie_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(messagesViewModle: MessagesViewModel(for: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023"),chatId: "bad51940-15ec-4ea3-ac2f-9b79bf9aa023", selectedProduct: .constant(nil), messageTitle: "메시지 타이틀")
            .environmentObject(ChatViewModel())
    }
}
