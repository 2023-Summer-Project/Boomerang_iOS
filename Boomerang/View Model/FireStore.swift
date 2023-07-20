//
//  MainViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FireStore: ObservableObject {
    @Published var products: [Product] = []
    
    let db = Firestore.firestore()
    
    init() {
        fetchProduct()
    }
    
    func fetchProduct() {
        let docRef = db.collection("Product").document("3YqLDLepWnn6J82A1IPP")
        
        docRef.getDocument(as: Product.self) { result in
            switch result {
            case .success(let product):
                self.products.append(product)
            case .failure(let error):
                print("Error decoding Product", error)
            }
        }
    }
}
