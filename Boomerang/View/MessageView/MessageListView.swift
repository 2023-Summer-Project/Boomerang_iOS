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
    @Binding var showMessageDetail: Bool
    @Binding var showExistingMEssageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var sortedChatList: [Chat] {
        chatViewModel.chatList.sorted(by: { $0.last_timestamp > $1.last_timestamp })
    }
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            NavigationLink(isActive: $showExistingMEssageDetail, destination: {
                MessageDetailView(messagesViewModle: MessagesViewModel(for: getChatIdOfSelectedProduct(selectedProduct?.id)), chatId: getChatIdOfSelectedProduct(selectedProduct?.id), selectedProduct: $selectedProduct, messageTitle: selectedProduct?.PRODUCT_NAME ?? "제목")
                    .environmentObject(chatViewModel)
            }, label: {})
            
            List {
                ForEach(sortedChatList) { chat in
                    NavigationLink(destination: {
                        MessageDetailView(messagesViewModle: MessagesViewModel(for: chat.id), chatId: chat.id, selectedProduct: $selectedProduct, messageTitle: chat.title)
                            .environmentObject(chatViewModel)
                    }, label: { MessageListRowView(chat: chat) })
                    .listRowBackground(Color("background"))
                }
                .onDelete(perform: {
                    //TODO: - Task of Remove chat
                    for index in $0 {
                        chatViewModel.removeChat(for: sortedChatList[index])
                    }
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
                .background(colorScheme == .light ? .white : Color("background"))
            }
        }
        .scrollContentBackground(.hidden)
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(showMessageDetail: .constant(false), showExistingMEssageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(ChatViewModel())
    }
}
