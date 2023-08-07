//
//  FireStore.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Combine
import SwiftUI

final class FireStoreViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchProduct()
    }
}

//MARK: - fetch Data
extension FireStoreViewModel {
    func fetchProduct() {
        products.removeAll()
        
        FireStoreModel.fetchDocuments()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Documents fetch completed.")
                case .failure(let error):
                    print("Error fetching documents: ", error)
                }
            }, receiveValue: { products in
                self.products = products
            })
            .store(in: &self.cancellables)
    }
}

//MARK: - add & delete data
extension FireStoreViewModel {    
    func uploadProduct(images: [UIImage], POST_CONTENT: String, POST_TITLE: String, PRICE: Int, OWNER_ID: String) {
        var images_map: Dictionary<String, String> = Dictionary<String, String>()
        
        for image in images {
            print(image.size.width, image.size.height)
            FireStoreModel.uploadImage(dataToUpload: image)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("image upload finished")
                    case .failure(let error):
                        print("image upload failed: ", error)
                    }
                }, receiveValue: { (storageReference, fileName) in
                    FireStoreModel.downloadURL(ref: storageReference)
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
                                let product: Dictionary<String, Any> = ["IMAGES_MAP": images_map, "AVAILABILITY": true, "LOCATION": "동백동", "PRODUCT_NAME": "", "PRODUCT_TYPE": "", "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID, "TIMESTAMP": Date()]
                                
                                FireStoreModel.uploadDocument(newProduct: product)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("write Document finished")
                                        case .failure(let error):
                                            print("write document failed: ", error)
                                        }
                                    }, receiveValue: {
                                        print("Document is successfully written!")
                                        self.fetchProduct()
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
        FireStoreModel.deleteDocument(id: target.id)
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
            FireStoreModel.deleteImage(fileName: key)
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
extension FireStoreViewModel {
    func searchProducts(_ target: String) {
        filteredProducts = FireStoreModel.filterProducts(target: target, products: products)
    }
}
