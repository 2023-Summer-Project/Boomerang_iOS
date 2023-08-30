//
//  Product.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Product: Identifiable {
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
    var TIMESTAMP: Timestamp
    var OWNER_NAME: String
    var PROFILE_IMAGE: String
    var LONGITUDE: Double
    var LATITUDE: Double
    var AVAILABLE_TIME: [String]
    var dateString: String {
        TIMESTAMP.dateValue().getDayAndTimeFormat()
    }
    var dateDiff: Int {
        Int(Date().timeIntervalSince(TIMESTAMP.dateValue()))
    }
}
