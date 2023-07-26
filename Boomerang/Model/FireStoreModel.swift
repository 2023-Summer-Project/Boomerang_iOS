//
//  FireStoreModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/25.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct FireStoreModel {
    static private let db = Firestore.firestore()
    
    static func filterProducts(target: String, products: [ProductInfo]) -> [ProductInfo] {
        let result = products.filter {
            return $0.1.POST_TITLE.contains(target) || $0.1.POST_CONTENT.contains(target)
        }
        
        return result
    }
    
    static func fetchAllDocuments() -> AnyPublisher<QuerySnapshot, Error> {
        return Future() { promise in
            db.collection("Product").getDocuments() { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(querySnapshot!))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchDocument(documentID: String) -> AnyPublisher<(String, Product), Error> {
        let docRef = db.collection("Product").document(documentID)
        
        return Future() { promise in
            docRef.getDocument(as: Product.self) { result in
                switch result {
                case .success(let result):
                    promise(.success((documentID, result)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchImage(imageName: String) -> AnyPublisher<UIImage?, Error> {
        let storage = Storage.storage()
        let gsReference = storage.reference(forURL: "gs://ios-demo-ae41b.appspot.com/")
        let islandRef = gsReference.child(imageName)
        
        return Future() { promise in
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(UIImage(data: data!)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func writeDocument(product: Dictionary<String, Any>) -> AnyPublisher<Bool, Error> {
        return Future() { promise in
            db.collection("Product").document(UUID().uuidString).setData(product) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func removeDocument(documentID: String) -> AnyPublisher<Bool, Error> {
        return Future() { promise in
            db.collection("Product").document(documentID).delete() { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
