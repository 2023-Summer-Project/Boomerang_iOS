//
//  MessageListRowView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/02.
//

import SwiftUI

struct MessageListRowView: View {
    var chat: Chat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(chat.title)
                .font(.title2)
            Text(chat.last_message)
                .font(.footnote)
        }
    }
}

struct MessageListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListRowView(chat: Chat(id: "e7ba25e7-0fc5-4d46-8bea-f2f3b33f6419", last_message: "넵 알겠습니다.", last_timestamp: 1690968618738974, title: "test"))
    }
}
