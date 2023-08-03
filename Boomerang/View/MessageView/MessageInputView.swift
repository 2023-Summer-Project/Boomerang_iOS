//
//  MessageInputView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/03.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var messageInput: String
    
    var body: some View {
        HStack {
            TextField("", text: $messageInput)
                .textFieldStyle(.roundedBorder)
            Button(action: {}, label: {
                Image(systemName: "arrow.forward.circle.fill")
                    .font(.title2)
            })
        }
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(messageInput: .constant(""))
    }
}
