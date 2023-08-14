//
//  TimestampView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/05.
//

import SwiftUI
import FirebaseFirestore

struct TimestampView: View {
    var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        if product.dateDiff < 86400 {
            Text("\(product.dateDiff.toFormattedTime()) 전")
        } else {
            Text(product.dateString)
        }
    }
}

struct LocationTimestampView_Previews: PreviewProvider {
    static var previews: some View {
        TimestampView(Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "맥북", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북", TIMESTAMP: Timestamp()))
    }
}

extension Int {
    func toFormattedTime() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko")
        
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full

        let formattedString = formatter.string(from: TimeInterval(self))!
        
        return formattedString
    }
}
