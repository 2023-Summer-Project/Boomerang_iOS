//
//  UserInfoService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/16.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

struct UserInfoService {
    static private let db = Firestore.firestore()
    
    static func fetchUserInfo() -> AnyPublisher<UserInfo?, Error> {
        let userId = Auth.auth().currentUser?.uid ?? "c0rIGlsb3JPmD2xMZMixWK7holT2"
        
        return Future() { promise in
            db.collection("User").document(userId).getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    if let document = document, document.exists {
                        let userInfo = document.data()!
                        
                        promise(.success(UserInfo(userName: userInfo["USERNAME"]! as! String, userEmail: userInfo["EMAIL"]! as! String, userProfileImage: userInfo["PROFILE_IMAGE"]! as! String)))
                    } else {
                        promise(.success(nil))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func uploadUserInfo(email: String, userName: String) -> AnyPublisher<Void, Error> {
        let userId = Auth.auth().currentUser!.uid
        
        return Future() { promise in
            db.collection("User").document(userId).setData([
                "AREA": [""],
                "EMAIL": email,
                "PROFILE_IMAGE": "",
                "UID": userId,
                "USERNAME": userName
            ]) { error in
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
