//
//  UserMessageView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/03.
//

import SwiftUI

struct UserMessageView: View {
    var message: Message
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(message.message)
                .padding(10)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(13)
        }
    }
}

struct UserMessageView_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageView(message: Message(message: "유저 테스트 입니다.", user_uid: "c0rIGlsb3JPmD2xMZMixWK7holT2", user_name: "ksjs1111", timestamp: 1.0))
    }
}
