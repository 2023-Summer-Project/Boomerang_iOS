//
//  RealtimeDatabaseModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//


import Combine
import FirebaseDatabase
import FirebaseAuth

struct ChatModel {
    static var ref: DatabaseReference = Database.database().reference()
    
    static func fetchChatList() -> AnyPublisher<String?, Never> {
        let subject = CurrentValueSubject<String?, Never>(nil)
        let handle = ref.child("user").child(Auth.auth().currentUser!.uid).child("chat_list").observe(.childAdded, with: { snapshot in
            subject.send(snapshot.key)
        })
        
        return subject.handleEvents(receiveCancel: {
            self.ref.removeObserver(withHandle: handle)
        })
        .eraseToAnyPublisher()
    }
    
    static func fetchChat(for chatId: String) -> AnyPublisher<Chat, Error> {
        return Future() { promise  in
            ref.child("chat").child(chatId).getData(completion: { (error, snapshot) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let chat = snapshot?.value as! [String: Any]
                    
                    promise(.success(Chat(id: chatId, last_message: chat["last_message"] as! String, last_timestamp: chat["last_timestamp"] as! Int, title: chat["title"] as! String)))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
//    static func fetchChat(for chatId: String) -> AnyPublisher<Chat?, Never> {
//        let subject = CurrentValueSubject<Chat?, Never>(nil)
//        let handle = ref.child("chat").observe(.childChanged, with: { snapshot in
//            print(snapshot)
//            let chat = snapshot.value as! [String: Any]
//
//            subject.send(Chat(id: chatId, last_message: chat["last_message"] as! String, last_timestamp: chat["last_timestamp"] as! Int, title: chat["title"] as! String))
//        })
//
//        return subject.handleEvents(receiveCancel: {
//            self.ref.removeObserver(withHandle: handle)
//        }).eraseToAnyPublisher()
//    }
    
    static func createChat(for productId: String, chatTitle: String, last_message: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            ref.child("chat").child(Auth.auth().currentUser!.uid + "_" + productId).setValue(["last_message": last_message, "last_timestamp": Int(trunc(Date().timeIntervalSince1970 * 1000)), "title": chatTitle] as [String : Any]) { (error, _) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func addChatId(_ chatId: String, to userId: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            ref.child("user").child(userId).child("chat_list").child(chatId).setValue("value") { (error, _) in
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
