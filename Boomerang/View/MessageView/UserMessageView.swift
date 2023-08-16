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
        HStack(alignment: .bottom) {
            Spacer()
            
            Text((message.timestamp / 1000).toHourMinuteFormat())
                .font(.system(size: 10))
                .padding(.trailing, -5)
            
            Text(message.message)
                .padding(10)
                .background(.indigo)
                .foregroundColor(.white)
                .cornerRadius(13)
        }
    }
}

struct UserMessageView_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageView(message: Message(message: "유저 테스트 입니다.", user_uid: "c0rIGlsb3JPmD2xMZMixWK7holT2", user_name: "ksjs1111", timestamp: 1))
    }
}

extension Int {
    func toHourMinuteFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current    //기기의 설정된 지역으로 시간 가져옴
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self)))
    }
}
