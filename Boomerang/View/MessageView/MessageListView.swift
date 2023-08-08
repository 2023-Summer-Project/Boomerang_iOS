//
//  MessageListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MessageListView: View {
    @ObservedObject var realtimeDatabaseViewModel: RealtimeDatabaseViewModel = RealtimeDatabaseViewModel()
    @State var messageInput: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(realtimeDatabaseViewModel.chatList) { chat in
                    NavigationLink(destination: {
                        MessageDetailView(chat, chatId: chat.id)
                            .environmentObject(realtimeDatabaseViewModel)
                    }, label: { MessageListRowView(chat: chat) })
                }
                .onDelete(perform: { _ in
                    //TODO: - Task of Remove chat
                })
            }
            .listStyle(.plain)
            .navigationTitle("채팅")
        }
        .onAppear {
            //realtimeDatabaseViewModel.getUserChats()
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
