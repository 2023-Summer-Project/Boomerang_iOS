//
//  RealtimeDatabaseModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//


import Combine
import FirebaseDatabase
import FirebaseAuth

struct RealtimeDatabaseModel {
    static var ref: DatabaseReference = Database.database().reference()
    
    static func fetchChatList() -> AnyPublisher<[String: String], Error> {
        return Future() { promise in
            ref.child("user").child(Auth.auth().currentUser!.uid).child("chat_list").getData(completion: {(error, snapshot) in
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
            ref.child("chat").child(chatId).getData(completion: {( error, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(snapshot?.value as! [String: String]))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchMessage(_ chatId: String) -> AnyPublisher<[Message], Error> {
        return Future() { promise in
            ref.child("messages").child(chatId).getData(completion: {( error, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let messages = snapshot?.value as! [String: Any]
                    let messageArray = messages.keys.map { key in
                        let message = messages[key] as! [String: String]

                        return Message(message: message["message"]!, id: message["uid"]!, user_name: message["user_name"]!, time_stamp: message["time_stamp"]!)
                    }

                    promise(.success(messageArray))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
