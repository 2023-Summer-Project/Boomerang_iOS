//
//  Product.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Foundation

struct Product: Codable, Hashable {
    var AVAILABILITY: Bool    //1: true, 0: false
    var LOCATION: String
    var OWNER_ID: String
    var POST_CONTENT: String
    var POST_TITLE: String
    var PRICE: Double
    var PRODUCT_NAME: String
    var PRODUCT_TYPE: String
}
