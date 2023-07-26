//
//  FireStore.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Combine
import SwiftUI

typealias ProductInfo = (String, Product, UIImage?)

final class FireStore: ObservableObject {
    @Published var products: [ProductInfo] = []
    @Published var filteredProducts: [ProductInfo] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchProduct()
    }
}

//MARK: - fetch Data
extension FireStore {
    func fetchProduct() {
        products.removeAll()
        
        FireStoreModel.fetchAllDocuments()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Documents fetch completed.")
                case .failure(let error):
                    print("Error fetching documents: ", error)
                }
            }, receiveValue: { querySnapshot in
                let _ = querySnapshot.documents.map { document in
                    FireStoreModel.fetchDocument(documentID: document.documentID)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Document fetch completed.")
                            case .failure(let error):
                                print("Error fetching document: ", error)
                            }
                        }, receiveValue: { (documentID, product) in
                            FireStoreModel.fetchImage(imageName: product.IMAGES[0])
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("Image fetch completed.")
                                    case .failure(let error):
                                        print("Error fetching Image: ", error)
                                    }
                                }, receiveValue: { image in
                                    self.products.append((documentID, product, image))
                                })
                                .store(in: &self.cancellables)
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &self.cancellables)
    }
}

//MARK: - add & delete data
extension FireStore {
    func addProduct(POST_CONTENT: String, POST_TITLE: String, PRICE: Int, OWNER_ID: String) {
        let product: Dictionary<String, Any> = ["AVAILABILITY": true, "LOCATION": "동백동", "PRODUCT_NAME": "", "PRODUCT_TYPE": "", "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID]
        
        FireStoreModel.writeDocument(product: product)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("write Document finished")
                case .failure(let error):
                    print("write document failed: ", error)
                }
            }, receiveValue: { _ in
                print("Document successfully written!")
            })
            .store(in: &self.cancellables)
        
        fetchProduct()
    }
    
    func removeProduct(documentID: String) {
        FireStoreModel.removeDocument(documentID: documentID)
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
extension FireStore {
    func searchProducts(_ target: String) {
        filteredProducts = FireStoreModel.filterProducts(target: target, products: products)
    }
}
