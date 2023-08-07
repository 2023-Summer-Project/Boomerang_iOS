//
//  Product.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Product: Codable, Hashable {
    var id: String
    var IMAGES_MAP: Dictionary<String, String>
    var IMAGE_MAP_KEYS: [String]
    var AVAILABILITY: Bool    //1: true, 0: false
    var LOCATION: String
    var OWNER_ID: String
    var POST_CONTENT: String
    var POST_TITLE: String
    var PRICE: Double
    var PRODUCT_NAME: String
    var PRODUCT_TYPE: String
    var TIMESTAMP: Timestamp
    var dateString: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: TIMESTAMP.dateValue())
    }
    var dateDiff: Int {
        return Int(Date().timeIntervalSince(TIMESTAMP.dateValue()))
    }
}
