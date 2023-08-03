//
//  MessageListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var realtimeDatabaseViewModel: RealtimeDatabaseViewModel = RealtimeDatabaseViewModel()
    @State var messageInput: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(realtimeDatabaseViewModel.chatList) { chat in
                    NavigationLink(destination: {
                        MessageDetailView(chatId: chat.id)
                            .environmentObject(realtimeDatabaseViewModel)
                    }, label: { MessageListRowView(chat: chat) })
                }
            }
            .listStyle(.plain)
            .navigationTitle("채팅")
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
