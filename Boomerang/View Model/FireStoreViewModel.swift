//
//  FireStore.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Combine
import SwiftUI
import CoreLocation

final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var userProducts: [Product] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getProduct()
        getUserProduct()
    }
}

//MARK: - fetch Data
extension ProductViewModel {
    func getProduct() {
        self.products.removeAll()
        
        FireStoreService.fetchProducts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Documents fetch completed.")
                    DirectoryManager.deleteTmpDirectory()
                    print("Temp Directory has been deleted")
                case .failure(let error):
                    print("Error fetching documents: ", error)
                }
            }, receiveValue: { products in
                self.products = products
            })
            .store(in: &self.cancellables)
    }
    
    func getUserProduct() {
        FireStoreService.fetchUserProducts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully fetched User Products")
                    DirectoryManager.deleteTmpDirectory()
                    print("Temp Directory has been deleted")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: { products in
                self.userProducts = products
            })
            .store(in: &self.cancellables)
    }
}

//MARK: - add & delete data
extension ProductViewModel {
    func uploadProduct(images: [UIImage], POST_CONTENT: String, POST_TITLE: String, PRICE: Int, OWNER_ID: String, PRODUCT_NAME: String, AVAILABLE_TIME: [Date], location: CLLocationCoordinate2D, OWNER_NAME: String, PROFILE_IMAGE: String) {
        var images_map: Dictionary<String, String> = Dictionary<String, String>()
        
        for image in images {
            FireStoreService.uploadImage(dataToUpload: image)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("image upload finished")
                    case .failure(let error):
                        print("image upload failed: ", error)
                    }
                }, receiveValue: { (storageReference, fileName) in
                    FireStoreService.downloadURL(ref: storageReference)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("download URL finished")
                            case .failure(let error):
                                print("download URL failed: ", error)
                            }
                        }, receiveValue: { url in
                            let stringURL: String = url.absoluteString
                            images_map[fileName] = stringURL
                            
                            if images.count == images_map.count {
                                GeoService.fetchAddress(location)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("successfully got Address")
                                        case .failure(let error):
                                            print("Error: ", error)
                                        }
                                    }, receiveValue: { LOCATION in
                                        let product: [String: Any] = ["IMAGES_MAP": images_map, "AVAILABILITY": true, "LOCATION": LOCATION, "PRODUCT_NAME": PRODUCT_NAME, "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID, "TIMESTAMP": Date(), "LONGITUDE": location.longitude, "LATITUDE": location.latitude, "AVAILABLE_TIME": [AVAILABLE_TIME[0].getTimeFormat(), AVAILABLE_TIME[1].getTimeFormat()], "OWNER_NAME": OWNER_NAME, "PROFILE_IMAGE": PROFILE_IMAGE]
                                        
                                        FireStoreService.uploadProduct(newProduct: product)
                                            .sink(receiveCompletion: { completion in
                                                switch completion {
                                                case .finished:
                                                    print("write Document finished")
                                                case .failure(let error):
                                                    print("write document failed: ", error)
                                                }
                                            }, receiveValue: {
                                                print("Document is successfully written!")
                                                self.getProduct()
                                            })
                                            .store(in: &self.cancellables)
                                    })
                                    .store(in: &self.cancellables)
                            }
                        })
                        .store(in: &self.cancellables)
                })
                .store(in: &self.cancellables)
        }
    }
    
    func deleteProduct(target: Product) {
        FireStoreService.deleteProduct(id: target.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("delete Document finished")
                case .failure(let error):
                    print("delete Document failed: ", error)
                }
            }, receiveValue: {
                print("Document is successfully deleted!")
            })
            .store(in: &self.cancellables)
        
        target.IMAGE_MAP_KEYS.forEach { key in
            FireStoreService.deleteImage(fileName: key)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("delete Image finished")
                    case .failure(let error):
                        print("delete Image failed: ", error)
                    }
                }, receiveValue: {
                    print("Image is successfully deleted!")
                })
                .store(in: &self.cancellables)
        }
    }
}

//MARK: - search data
extension ProductViewModel {
    func searchProducts(_ target: String) {
        filteredProducts = FireStoreService.filterProducts(target: target, products: products)
    }
}

//MARK: - get String Format of Date
extension Date {
    func getTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: self)
    }
    
    func getDayFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: self)
    }
    
    func getDayAndTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        return formatter.string(from: self)
    }
}
