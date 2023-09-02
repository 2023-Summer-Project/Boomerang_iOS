//
//  FireStoreService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/25.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

struct FireStoreService {
    static private let db = Firestore.firestore()
    static private let storage = Storage.storage()
    static private let gsReference = storage.reference(forURL: "gs://ios-demo-ae41b.appspot.com/")
}

//MARK: - Product
extension FireStoreService {
    static func fetchFilteredProducts(_ products: [Product], target: String) -> [Product] {
        let result = products.filter {
            return $0.POST_TITLE.contains(target) || $0.POST_CONTENT.contains(target)
        }
        
        return result
    }
    
    static func fetchProducts() -> AnyPublisher<[Product], Error> {
        return Future() { promise in
            db.collection("Product")
                .order(by: "TIMESTAMP", descending: true)
                .getDocuments(source: FirestoreSource.server) { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(getProductArray(querySnapshot)!))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchUserProducts() -> AnyPublisher<[Product], Error> {
        return Future() { promise in
            if let userId = Auth.auth().currentUser?.uid {
                db.collection("Product")
                    .whereField("OWNER_ID", isEqualTo: userId)
//                    .order(by: "TIMESTAMP", descending: true)
                    .getDocuments(source: FirestoreSource.server) { (querySnapshot, error) in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(getProductArray(querySnapshot)!))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func uploadProduct(newProduct: Dictionary<String, Any>) -> AnyPublisher<Void, Error> {
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
    
    static func deleteProduct(id: String) -> AnyPublisher<Void, Error> {
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

//MARK: - Transaction
extension FireStoreService {
    static func fetchRequestedTransaction(role: String, status: String...) -> AnyPublisher<[Transaction]?, Error> {
        let subject = CurrentValueSubject<[Transaction]?, Error>(nil)
        let listener = db.collection("Transaction")
            .whereField(role, isEqualTo: Auth.auth().currentUser!.uid)
            .whereFilter(Filter.orFilter(
                status.map {
                    Filter.whereField("STATUS", isEqualTo: $0)
                }
            ))
            .addSnapshotListener { (querySnapshot, error) in
                guard (querySnapshot?.documents) != nil else {
                    subject.send(completion: .failure(error!))
                    return
                }
                
                subject.send(getTransactionArray(querySnapshot))
            }
        
        return subject.handleEvents(receiveCancel: {
            listener.remove()
        })
        .eraseToAnyPublisher()
    }
    
    static func fetchCompletedTransaction(status: String...) -> AnyPublisher<[Transaction]?, Error> {
        let subject = CurrentValueSubject<[Transaction]?, Error>(nil)
        let listener = db.collection("Transaction")
            .whereFilter(Filter.orFilter(
                status.map {
                    Filter.whereField("STATUS", isEqualTo: $0)
                }
            ))
            .addSnapshotListener { (querySnapshot, error) in
                //TODO: document가 없을때 처리
                guard (querySnapshot?.documents) != nil else {
                    subject.send(completion: .failure(error!))
                    return
                }
                
                subject.send(getTransactionArray(querySnapshot))
            }
        
        return subject.handleEvents(receiveCancel: {
            listener.remove()
        })
        .eraseToAnyPublisher()
    }
    
    static func createTransaction(_ docData: [String: Any]) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            db.collection("Transaction").document(UUID().uuidString).setData(docData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func updateTransactionStatus(of transactionId: String, status: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            db.collection("Transaction").document(transactionId).updateData(["STATUS": status]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: - Helper
extension FireStoreService {
    static func getProductArray(_ querySnapshot: QuerySnapshot?) -> [Product]? {
        let products = querySnapshot?.documents.map { document in
            let data = document.data()
            let images_map: Dictionary<String, String> = data["IMAGES_MAP"] as! Dictionary<String, String>
            let image_map_keys: Array<String> = images_map.keys.sorted(by: {$0 < $1})
            
            return Product(id: document.documentID, IMAGES_MAP: images_map, IMAGE_MAP_KEYS: image_map_keys, AVAILABILITY: (data["AVAILABILITY"] != nil), LOCATION: data["LOCATION"] as! String, OWNER_ID: data["OWNER_ID"] as! String, POST_CONTENT: data["POST_CONTENT"] as! String, POST_TITLE: data["POST_TITLE"] as! String, PRICE: data["PRICE"] as! Double, PRODUCT_NAME: data["PRODUCT_NAME"] as! String, TIMESTAMP: data["TIMESTAMP"] as! Timestamp, OWNER_NAME: data["OWNER_NAME"] as! String, PROFILE_IMAGE: data["PROFILE_IMAGE"] as! String, LONGITUDE: data["LONGITUDE"] as! Double, LATITUDE: data["LATITUDE"] as! Double, AVAILABLE_TIME: data["AVAILABLE_TIME"] as! [String])
        }
        
        return products
    }
    
    static func getTransactionArray(_ querySnapshot: QuerySnapshot?) -> [Transaction]? {
        let transactions = querySnapshot?.documents.map { document in
            let data = document.data()
            
            return Transaction(id: document.documentID, DEPOSIT: data["DEPOSIT"] as! Int, END_DATE: data["END_DATE"] as! Timestamp, LOCATION: data["LOCATION"] as! String, PRICE: data["PRICE"] as! Int, PRODUCT_ID: data["PRODUCT_ID"] as! String, PRODUCT_NAME: data["PRODUCT_NAME"] as! String, RENTEE: data["RENTEE"] as! String, RENTER: data["RENTER"] as! String, START_DATE: data["START_DATE"] as! Timestamp, STATUS: TransactionStatus(rawValue: data["STATUS"] as! String)!, PRODUCT_IMAGE: data["PRODUCT_IMAGE"] as! String)
        }
        
        return transactions
    }
}
