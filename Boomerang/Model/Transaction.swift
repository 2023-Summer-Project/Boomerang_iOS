//
//  Transaction.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/27.
//

import Foundation
import FirebaseFirestore

struct Transaction: Identifiable {
    var id: String
    var DEPOSIT: Int
    var END_DATE: Timestamp
    var LOCATION: String
    var PRICE: Int
    var PRODUCT_ID: String
    var PRODUCT_NAME: String
    var RENTEE: String
    var RENTER: String
    var START_DATE: Timestamp
    var STATUS: TransactionStatus
    var PRODUCT_IMAGE: String
}

enum TransactionStatus: String {
    case required = "REQUESTED"
    case accepted = "ACCEPTED"
    case rejected = "REJECTED"
    case not_returned = "NOT_RETURNED"
    case completed = "COMPLETED"
}
