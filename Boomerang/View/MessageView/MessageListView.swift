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
            VStack {
                HStack {
                    Text("채팅")
                    
                    Spacer()
                }
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width)
            }
            .font(.title2)
            .bold()
            .padding([.leading, .top, .trailing])
            .background(colorScheme == .light ? .white : .black)
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(selectedProduct: .constant(nil))
            .environmentObject(ChatViewModel())
            .environmentObject(UserInfoViewModel())
    }
}
