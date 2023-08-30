//
//  TransactionLocationMapView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/15.
//

import SwiftUI
import MapKit

struct TransactionLocationMapView: View {
    @State var region: MKCoordinateRegion
    @State var places: [Place]

    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: places) { item in
            //TODO: iOS 17
//            if #available(iOS 17, *) {
//
//            } else {
//
//            }
//            MapMarker(coordinate: item.location, tint: .indigo)
            MapAnnotation(coordinate: item.location) {
                Image("MapMaker")
                    .resizable()
                    .frame(width: 117 / 3, height: 170 / 3)
                    .offset(y: -30)
            }
        }
        //.allowsHitTesting(false)
    }
}

struct TransactionLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionLocationMapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)), places: [Place(location: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914))])
    }
}
