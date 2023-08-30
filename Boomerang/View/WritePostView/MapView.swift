//
//  MapView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/22.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    let mapView: MKMapView = MKMapView()
    let manager: CLLocationManager = CLLocationManager()
    
    final class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
            self.parent.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        }
                
        //MARK: - MapView의 화면이 이동하면 호출되는 메서드
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.selectedCoordinate = mapView.centerCoordinate
            
            print(parent.selectedCoordinate)
        }
        
        //MARK: - 권한이 변경 되었을때 호출하는 메서드
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
                self.moveFocusOnUserLocation()
            }
        }
        
        //MARK: - 현재 사용자 위치로 이동
        func moveFocusOnUserLocation() {
            parent.mapView.showsUserLocation = true
            parent.mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        manager.delegate = context.coordinator
        
        let status = manager.authorizationStatus    //권한 허용 여부
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if status == .notDetermined {
            manager.requestAlwaysAuthorization()    //권한이 허용되지 않았으면 요청
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

struct SelectLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(selectedCoordinate: .constant(CLLocationCoordinate2D(latitude: 0, longitude: 0)))
    }
}
