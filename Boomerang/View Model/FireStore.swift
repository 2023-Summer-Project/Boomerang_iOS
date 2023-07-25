//
//  FireStore.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Combine

typealias ProductInfo = (String, Product, UIImage?)

final class FireStore: ObservableObject {
    @Published var products: [ProductInfo] = []
    @Published var filteredProducts: [ProductInfo] = []
    @Published var image: UIImage? = UIImage(systemName: "info.circle")
    
    let db = Firestore.firestore()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchProduct()
    }
}

//MARK: - fetch Data
extension FireStore {
    //fetch Product Document
    func fetchProduct() {
        products.removeAll()
        
        db.collection("Product").getDocuments() { (querySnapshot, error) in
            if let error {
                print("Error getting documents: \(error)")
            } else {
                let _ = querySnapshot!.documents.map {
                    let docRef = self.db.collection("Product").document($0.documentID)
                    
                    docRef.getDocument(as: Product.self) { result in
                        switch result {
                        case .success(let product):
                            self.fetchImage(imageName: product.IMAGES[0]) {
                                self.products.append((docRef.documentID, product, $0))
                            }
                            
                        case .failure(let error):
                            print("Error decoding Product", error)
                        }
                    }
                }
            }
        }
    }
    
    //fetch Image
    func fetchImage(imageName: String, completion: @escaping (UIImage?) -> ()) {
        let storage = Storage.storage()
        let gsReference = storage.reference(forURL: "gs://ios-demo-ae41b.appspot.com/")
        let islandRef = gsReference.child(imageName)
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("fetchImage(imageName:): - ", error)
          } else {
              completion(UIImage(data: data!))
          }
        }
    }
}

//MARK: - add & delete data
extension FireStore {
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

//MARK: - search data
extension FireStore {
    func searchProducts(_ target: String) {
        filteredProducts = FireStoreModel.filterProducts(target: target, products: products)
    }
}
