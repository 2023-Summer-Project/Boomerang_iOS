//
//  FireStore.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import Combine
import SwiftUI

typealias ProductInfo = (Product, UIImage?)

final class FireStoreViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var tmpArray: [ProductInfo] = []
    
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
    func addProduct(imageData: Data, POST_CONTENT: String, POST_TITLE: String, PRICE: Int, OWNER_ID: String) {
        let product: Dictionary<String, Any> = ["IMAGES": ["test.jpg"], "AVAILABILITY": true, "LOCATION": "동백동", "PRODUCT_NAME": "", "PRODUCT_TYPE": "", "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID]
        
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
            })
            .store(in: &self.cancellables)
        
        FireStoreModel.uploadImage(dataToUpload: imageData)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("image upload finished")
                case .failure(let error):
                    print("image upload failed: ", error)
                }
            }, receiveValue: { _ in
                //TODO:
                print("image upload success")
            })
            .store(in: &self.cancellables)
        
        fetchProduct()
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
