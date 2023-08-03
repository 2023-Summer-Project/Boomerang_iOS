//
//  MessageDetailVie.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/02.
//

import SwiftUI
import FirebaseAuth

struct MessageDetailView: View {
    @EnvironmentObject var realtimeDatabaseViewModel: RealtimeDatabaseViewModel
    @State var messageInput: String = ""
    
    var chatId: String
    var sortedMessages: [Message] {        
        realtimeDatabaseViewModel.messages[chatId, default: []]
            .sorted(by: { $0.time_stamp < $1.time_stamp })
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(sortedMessages, id: \.time_stamp) { message in
                    if message.id == Auth.auth().currentUser?.uid {
                        UserMessageView(message: message)
                    } else {
                        OtherUserMessageView(message: message)
                    }
                }
            }
            
            MessageInputView(messageInput: $messageInput)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageDetailVie_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(chatId: "e7ba25e7-0fc5-4d46-8bea-f2f3b33f6419")
            .environmentObject(RealtimeDatabaseViewModel())
    }
}
