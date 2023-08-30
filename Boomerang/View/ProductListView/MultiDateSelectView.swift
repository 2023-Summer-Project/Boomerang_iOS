//
//  MultiDateSelectView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/21.
//

import SwiftUI

struct MultiDateSelectView: View {
    @State private var selectedDates: Set<DateComponents> = []
    @State private var cnt: Int = 0
    
    var body: some View {
        VStack {
            MultiDatePicker("희망하는 날짜를 선택해 주세요.", selection: $selectedDates, in: Date.now...)
                .datePickerStyle(.graphical)
            
            Button(action: {}, label: {
                HStack {
                    Spacer()
                    
                    Text("선택하기")
                        .font(.title2)
                        .padding(.all, 8)
                        .background(.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            })
            .padding([.trailing])
        }
//        .onChange(of: selectedDates) { newValue in
//            if cnt > 1 && newValue.count != cnt {
//                selectedDates = []
//                cnt = 0
//            } else if newValue.count == 2 {
//                var tmp: Set<DateComponents> = []
//                var year: Int?
//                var month: Int?
//                var startDay: Int?
//                var endDay: Int?
//
//                for component in newValue.sorted(by: { $0.day! < $1.day! }) {
//                    if year == nil {
//                        year = component.year
//                    }
//
//                    if month == nil {
//                        month = component.month
//                    }
//
//                    if startDay == nil {
//                        startDay = component.day
//                    } else {
//                        endDay = component.day
//                    }
//                }
//
//
//                for day in startDay!...endDay! {
//                    tmp.insert(DateComponents(year: year, month: month, day: day))
//                }
//
//                selectedDates = tmp
//                cnt = selectedDates.count
//            } else {
//                cnt = newValue.count
//            }
//        }
    }
}

struct MultiDateSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MultiDateSelectView()
    }
}
