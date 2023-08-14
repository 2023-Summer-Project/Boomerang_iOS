//
//  Chat.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/02.
//

import Foundation

struct Chat: Identifiable {
    var id: String
    var last_message: String
    var last_timestamp: Int
    var title: String
}
