//
//  MessageListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MessageListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showMessageDetail: Bool
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var sortedChatList: [Chat] {
        chatViewModel.chatList.sorted(by: { $0.last_timestamp > $1.last_timestamp })
    }
    
    var body: some View {
        List {
            ForEach(sortedChatList) { chat in
                NavigationLink(destination: {
                    MessageDetailView(messagesViewModel: MessagesViewModel(for: chat.id), selectedProduct: $selectedProduct, messageTitle: chat.title)
                        .environmentObject(chatViewModel)
                        .environmentObject(userInfoViewModel)
                }, label: { MessageListRowView(chat: chat) })
            }
            .onDelete(perform: { indexs in
                for index in indexs {
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
            .background(colorScheme == .light ? .white : .black)
        }
        .navigationDestination(isPresented: $showExistingMessageDetail, destination: {
            MessageDetailView(messagesViewModel: MessagesViewModel(for: getChatIdOfSelectedProduct(selectedProduct?.id)), selectedProduct: $selectedProduct, messageTitle: selectedProduct?.PRODUCT_NAME ?? "제목")
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
        })
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(showMessageDetail: .constant(false), showExistingMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(ChatViewModel())
            .environmentObject(UserInfoViewModel())
    }
}
