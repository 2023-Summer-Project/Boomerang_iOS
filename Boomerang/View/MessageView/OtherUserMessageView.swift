//
//  OtherUserMessageView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/03.
//

import SwiftUI

struct OtherUserMessageView: View {
    var message: Message
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(message.user_name)
                    .font(.footnote)
                    .padding(.bottom, -5)
                Text(message.message)
                    .padding(10)
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(13)
            }
            Spacer()
        }
    }
}

struct OtherUserMessageView_Previews: PreviewProvider {
    static var previews: some View {
        OtherUserMessageView(message: Message(message: "상대 유저 테스트 입니다.", user_uid: "AwhLiVkek2b4s2XwrggAkorn4nA3", user_name: "Ados", timestamp: "1"))
    }
}
