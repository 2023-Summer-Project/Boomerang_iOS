//
//  Place.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/22.
//

import Foundation
import SwiftUI
import CoreLocation

struct Place: Identifiable {
    var id: UUID = UUID()
    var location: CLLocationCoordinate2D    
}
