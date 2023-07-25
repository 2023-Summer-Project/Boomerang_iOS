//
//  FireStoreModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/25.
//

import Foundation

struct FireStoreModel {
    static func filterProducts(target: String, products: [ProductInfo]) -> [ProductInfo] {
        let result = products.filter {
            return $0.1.POST_TITLE.contains(target) || $0.1.POST_CONTENT.contains(target)
        }
        
        return result
    }
}
