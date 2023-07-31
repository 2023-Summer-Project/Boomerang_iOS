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
        var imageURLs: [String] = [""]
        
        for image in images {
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
                            imageURLs.append(stringURL)
                            
                            if images.count + 1 == imageURLs.count {
                                let product: Dictionary<String, Any> = ["IMAGES": imageURLs, "AVAILABILITY": true, "LOCATION": "동백동", "PRODUCT_NAME": "", "PRODUCT_TYPE": "", "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID]
                                
                                FireStoreModel.addDocument(newProduct: product)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("write Document finished")
                                        case .failure(let error):
                                            print("write document failed: ", error)
                                        }
                                    }, receiveValue: { _ in
                                        print("Document successfully written!")
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
    
    func deleteProduct(targetID: String) {
        FireStoreModel.deleteDocument(id: targetID)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("remove Document finished")
                case .failure(let error):
                    print("remove Document failed: ", error)
                }
            }, receiveValue: { _ in
                print("Document successfully removed!")
            })
            .store(in: &self.cancellables)
    }
}

//MARK: - search data
extension FireStoreViewModel {
    func searchProducts(_ target: String) {
        filteredProducts = FireStoreModel.filterProducts(target: target, products: products)
    }
}
