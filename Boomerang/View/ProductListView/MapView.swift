//
//  MapView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/15.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))

    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
