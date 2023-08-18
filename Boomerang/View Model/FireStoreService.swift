//
//  FireStoreService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/25.
//

import Combine
//import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct FireStoreService {
    static private let db = Firestore.firestore()
    static private let storage = Storage.storage()
    static private let gsReference = storage.reference(forURL: "gs://ios-demo-ae41b.appspot.com/")
    
    static func filterProducts(target: String, products: [Product]) -> [Product] {
        let result = products.filter {
            return $0.POST_TITLE.contains(target) || $0.POST_CONTENT.contains(target)
        }
        
        return result
    }
    
    static func fetchDocuments() -> AnyPublisher<[Product], Error> {
        return Future() { promise in
            db.collection("Product").order(by: "TIMESTAMP", descending: true).getDocuments(source: FirestoreSource.server) { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let products = querySnapshot?.documents.map { document in
                        let data = document.data()
                        let images_map: Dictionary<String, String> = data["IMAGES_MAP"] as! Dictionary<String, String>
                        let image_map_keys: Array<String> = images_map.keys.sorted(by: {$0 < $1})
                        
                        return Product(id: document.documentID, IMAGES_MAP: images_map,IMAGE_MAP_KEYS: image_map_keys, AVAILABILITY: (data["AVAILABILITY"] != nil), LOCATION: data["LOCATION"] as! String, OWNER_ID: data["OWNER_ID"] as! String, POST_CONTENT: data["POST_CONTENT"] as! String, POST_TITLE: data["POST_TITLE"] as! String, PRICE: data["PRICE"] as! Double, PRODUCT_NAME: data["PRODUCT_NAME"] as! String, PRODUCT_TYPE: data["PRODUCT_TYPE"] as! String, TIMESTAMP: data["TIMESTAMP"] as! Timestamp)
                    }
                    
                    promise(.success(products!))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func getOwnerIdFromProductId(_ productId: String) -> AnyPublisher<String, Error> {
        return Future() { promise in
            db.collection("Product").document(productId).getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    if let document = document, document.exists {
                        promise(.success(document["OWNER_ID"] as! String))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func uploadDocument(newProduct: Dictionary<String, Any>) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            db.collection("Product").document(UUID().uuidString).setData(newProduct) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func deleteDocument(id: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            db.collection("Product").document(id).delete() { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func uploadImage(dataToUpload image: UIImage) -> AnyPublisher<(StorageReference, String), Error> {
        let fileName: String = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "_")
        let imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
        let riversRef = gsReference.child(fileName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        return Future() { promise in
            riversRef.putData(imageData, metadata: metaData) { (metaData, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((riversRef, fileName)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func deleteImage(fileName: String) -> AnyPublisher<Void, Error> {
        let riversRef = gsReference.child(fileName)
        
        return Future() { promise in
            riversRef.delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func downloadURL(ref: StorageReference) -> AnyPublisher<URL, Error> {
        return Future() { promise in
            ref.downloadURL { (url, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(url!))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
