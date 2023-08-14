//
//  MessageModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/10.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

struct MessageModel {
    static var ref: DatabaseReference = Database.database().reference()
    
    static func fetchRealtimeMessage(of chatId: String) -> AnyPublisher<Message?, Never> {
        let subject = CurrentValueSubject<Message?, Never>(nil)    //nil 초기값 전달
        let handle = ref.child("messages").child(chatId).observe(.childAdded, with: { snapshot in
            let message = snapshot.value as! [String: Any]
            
            subject.send(Message(message: message["message"]! as! String, user_uid: message["user_uid"]! as! String, user_name: message["user_name"]! as! String, timestamp: message["timestamp"]! as! Int))
        })
        
        return subject.handleEvents(receiveCancel: {
            self.ref.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    
    static func uploadMessage(newMessage: String, to chatId: String) -> AnyPublisher<Void, Error> {
        //TODO: - modify User Name
        return Future() { promise in
            ref.child("messages").child(chatId).child(UUID().uuidString).setValue(["message": newMessage, "timestamp": Int(trunc(Date().timeIntervalSince1970 * 1000)), "user_uid": Auth.auth().currentUser!.uid, "user_name": "ksjs1111"] as [String : Any]) { (error, _) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func updateChatInfo(_ message: String, title chatTitle: String, updateTime: Int, to chatId: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            let childUpdates = ["/chat/\(chatId)/last_message": message,
                               "/chat/\(chatId)/last_timestamp": updateTime,
                               "/chat/\(chatId)/title": chatTitle] as [String : Any]
            
            ref.updateChildValues(childUpdates) { (error, _) in
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
