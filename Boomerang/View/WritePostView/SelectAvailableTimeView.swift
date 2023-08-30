//
//  SelectAvailableTimeView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/24.
//

import SwiftUI

struct SelectAvailableTimeView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("거래 가능시간")
                .bold()
            
            HStack {
                DatePicker("시작 시간", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                Divider()
                
                DatePicker("종료 시간", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
        }
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 30
        }
        .onDisappear {
            UIDatePicker.appearance().minuteInterval = 1
        }
        .padding(.bottom, 10)
    }
}

struct SelectAvailableTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAvailableTimeView(startTime: .constant(Date()), endTime: .constant(Date()))
    }
}
