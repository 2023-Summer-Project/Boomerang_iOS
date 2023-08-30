//
//  GeoService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/24.
//

import CoreLocation
import Combine

struct GeoService {
    static func fetchAddress(_ location: CLLocationCoordinate2D) -> AnyPublisher<String, Error> {
        let findLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        return Future() { promise in
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { (placemark, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    var result: String = ""
                    
                    if let address: [CLPlacemark] = placemark {
                        if let area = address.last?.locality {
                            result = result + area + " "
                        }
                        
                        if let name = address.last?.subLocality {
                            result += name
                        }
                    }
                    
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
