//
//  MessageListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MessageListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showTabbar: Bool
    @Binding var showMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var sortedChatList: [Chat] {
        chatViewModel.chatList.sorted(by: { $0.last_timestamp > $1.last_timestamp })
    }
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $showMessageDetail, destination: {
                MessageDetailView(messagesViewModle: MessagesViewModel(for: nil), chatId: nil, showTabbar: $showTabbar, selectedProduct: $selectedProduct, messageTitle: selectedProduct?.PRODUCT_NAME ?? "제목")
                    .environmentObject(chatViewModel)
            }, label: {})
            
            List {
                ForEach(sortedChatList) { chat in
                    NavigationLink(destination: {
                        MessageDetailView(messagesViewModle: MessagesViewModel(for: chat.id), chatId: chat.id, showTabbar: $showTabbar, selectedProduct: $selectedProduct, messageTitle: chat.title)
                            .environmentObject(chatViewModel)
                    }, label: { MessageListRowView(chat: chat) })
                }
                .onDelete(perform: { _ in
                    //TODO: - Task of Remove chat
                })
            }
            .listStyle(.plain)
            .navigationTitle("채팅")
            .safeAreaInset(edge: .top) {
                HStack {
                    Text("채팅")
                        .font(.title2)
                        .bold()
                        .padding()
                    
                    Spacer()
                }
                .background(colorScheme == .light ? .white : .black)
            }
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(showTabbar: .constant(true), showMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(ChatViewModel())
    }
}
