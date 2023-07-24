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
    @Published var products: [(String, Product)] = []
    
    let db = Firestore.firestore()
    
    init() {
        fetchProduct()
    }
    
    func fetchProduct() {
        products = []
        
        db.collection("Product").getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                let _ = querySnapshot!.documents.map {
                    let docRef = self.db.collection("Product").document($0.documentID)
                    
                    docRef.getDocument(as: Product.self) { result in
                        switch result {
                        case .success(let product):
                            self.products.append((docRef.documentID, product))
                        case .failure(let error):
                            print("Error decoding Product", error)
                        }
                    }
                }
            }
        }
    }
    
    func addProduct(POST_CONTENT: String, POST_TITLE: String, PRICE: Int, OWNER_ID: String) {
        let product: Dictionary<String, Any> = ["AVAILABILITY": true, "LOCATION": "동백동", "PRODUCT_NAME": "", "PRODUCT_TYPE": "", "POST_CONTENT": POST_CONTENT, "POST_TITLE": POST_TITLE, "PRICE": PRICE, "OWNER_ID": OWNER_ID]
        
        db.collection("Product").document(UUID().uuidString).setData(product) { error in
            if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully written!")
                }
        }
        
        fetchProduct()
    }
    
    func removeProduct(documentId: String) {
        db.collection("Product").document(documentId).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
