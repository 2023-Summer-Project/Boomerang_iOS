//
//  RealtimeDatabaseModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//


import Combine
import FirebaseDatabase
import FirebaseAuth
import Foundation

struct RealtimeDatabaseModel {
    static var ref: DatabaseReference = Database.database().reference()
    
    static func fetchChatList() -> AnyPublisher<[String: String], Error> {
        return Future() { promise in
            ref.child("user").child(Auth.auth().currentUser!.uid).child("chat_list").getData(completion: { (error, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(snapshot?.value as! [String: String]))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchChat(chatId: String) -> AnyPublisher<[String: String], Error> {
        return Future() { promise  in
            ref.child("chat").child(chatId).getData(completion: { (error, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(snapshot?.value as! [String: String]))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchMessage(_ chatId: String) -> AnyPublisher<Message?, Never> {
        let subject = CurrentValueSubject<Message?, Never>(nil)    //nil 초기값 전달
        let handle = ref.child("messages").child(chatId).observe(.childAdded, with: { snapshot in
            let message = snapshot.value as! [String: String]
            subject.send(Message(message: message["message"]!, user_uid: message["user_uid"]!, user_name: message["user_name"]!, timestamp: message["timestamp"]!))
            })
        
        return subject.handleEvents(receiveCancel: {
            self.ref.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    
    static func uploadMessage(newMessage: String, chatId: String) -> AnyPublisher<Void, Error> {
        //TODO: - modify User Name
        return Future() { promise in
            ref.child("messages").child(chatId).child(UUID().uuidString).setValue(["message": newMessage, "timestamp": String(Date().timeIntervalSince1970), "user_uid": Auth.auth().currentUser!.uid, "user_name": "ksjs1111"] as [String : Any]) { (error, _) in
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
