//
//  MessageListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel()
    @State var showTabbar: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(chatViewModel.chatList) { chat in
                    NavigationLink(destination: {
                        MessageDetailView(messagesViewModle: MessagesViewModel(for: chat.id), showTabbar: $showTabbar, chatId: chat.id, chatInfo: chat)
                    }, label: { MessageListRowView(chat: chat) })
                }
                .onDelete(perform: { _ in
                    //TODO: - Task of Remove chat
                })
            }
            .listStyle(.plain)
            .navigationTitle("채팅")
            .toolbar(showTabbar ? .visible : .hidden, for: .tabBar)
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
