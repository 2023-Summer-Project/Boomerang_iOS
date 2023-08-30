//
//  SelectDateView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/20.
//

import SwiftUI
import FirebaseFirestore

struct SelectDateView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @Binding var showSelectDateView: Bool
    
    var price: Double
    var product: Product
    
    var body: some View {
        VStack {
            DatePicker("대여 날짜", selection: $startDate, in: Date.now..., displayedComponents: [.date])
                .padding([.top, .bottom])
            
            DatePicker("반납 날짜", selection: $endDate, in: startDate... ,displayedComponents: [.date])
                .padding([.bottom])
            
            HStack {
                Text("대여비:")
                
                Spacer()
                
                Text("\(abs(startDate.getDayDiff(endDate) * Int(price)))")
                    .foregroundColor(.indigo)
            }
            .bold()
            
            Button(action: {
                transactionViewModel.createTransaction(product, abs(startDate.getDayDiff(endDate) * Int(price)), startDate: startDate, endDate: endDate)
                
                showSelectDateView = false
            }, label: {
                HStack {
                    Text("선택하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.indigo)
                .cornerRadius(10)
            })
        }
        .padding()
    }
}

extension Date {
    func getDayDiff(_ date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDay = formatter.date(from :formatter.string(from: self))
        let endDay = formatter.date(from: formatter.string(from: date))
        
        let calendar = Calendar.current
        let compoents = calendar.dateComponents([.day], from: startDay ?? Date(), to: endDay ?? Date())
        
        if let result = compoents.day {
            return result + 1
        } else {
            return 0
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateView(showSelectDateView: .constant(true), price: 1000.0, product: Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", TIMESTAMP: Timestamp(date: Date()), OWNER_NAME: "test name", PROFILE_IMAGE: "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/2023_summer_project.png?alt=media&token=692ddad2-7b3f-4b5d-b5aa-507a9d994d97", LONGITUDE: 127.15110757397726, LATITUDE: 37.283673549013166, AVAILABLE_TIME: ["오후 5시 00분", "오후 10시 00분"]))
            .environmentObject(TransactionViewModel())
    }
}
