//
//  MessageService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/10.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

struct MessagesService {
    private static var ref: DatabaseReference = Database.database().reference()
    
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
    
    static func uploadMessage(newMessage: String, chatTitle: String ,updateTime: Int, senderName: String ,to chatId: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            let messageUUID = UUID().uuidString
            let childUpdates = [
                "/chat/\(chatId)/last_message": getSubString(newMessage),
                "/chat/\(chatId)/last_timestamp": updateTime,
                "/chat/\(chatId)/title": chatTitle,
                "messages/\(chatId)/\(messageUUID)/message": newMessage,
                "messages/\(chatId)/\(messageUUID)/timestamp": updateTime,
                "messages/\(chatId)/\(messageUUID)/user_uid": Auth.auth().currentUser!.uid,
                "messages/\(chatId)/\(messageUUID)/user_name": senderName
            ] as [String : Any]
            
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

//MARK: - Helper
extension MessagesService {
    private static func getSubString(_ message: String) -> String {
        if message.count > 30 {
            let startIndex = message.startIndex
            let lastIndex = message.index(startIndex, offsetBy: 29)
            
            return String(message[startIndex...lastIndex]) + "..."
        } else {
            return message
        }
    }
}
