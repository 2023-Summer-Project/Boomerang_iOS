//
//  ChatService.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//


import Combine
import Foundation
import FirebaseDatabase
import FirebaseAuth

struct ChatService {
    static private var ref: DatabaseReference = Database.database().reference()
    static private var cancellables = Set<AnyCancellable>()
    
    static func fetchChatList() -> AnyPublisher<String?, Never> {
        let subject = CurrentValueSubject<String?, Never>(nil)
        let handle = ref.child("user").child(Auth.auth().currentUser?.uid ?? "").child("chat_list").observe(.childAdded, with: { snapshot in
            subject.send(snapshot.key)
        })
        
        return subject.handleEvents(receiveCancel: {
            self.ref.removeObserver(withHandle: handle)
        })
        .eraseToAnyPublisher()
    }
    
    static func fetchChat(for chatId: String) -> AnyPublisher<Chat?, Never> {
        let subject = CurrentValueSubject<Chat?, Never>(nil)
        let handle = ref.child("chat").child(chatId).observe(.value, with: { snapshot in
            let chat = snapshot.value as? [String: Any]
            
            if let chat {
                subject.send(Chat(id: chatId, last_message: chat["last_message"] as! String, last_timestamp: chat["last_timestamp"] as! Int, title: chat["title"] as! String))
            }
        })

        return subject.handleEvents(receiveCancel: {
            self.ref.removeObserver(withHandle: handle)
        }).eraseToAnyPublisher()
    }
    
    static func createChat(for chatId: String, chatTitle: String, last_message: String, newMessage: String, senderName: String) -> AnyPublisher<Void, Error> {
        return Future() { promise in
            let messageUUID: String = UUID().uuidString
            let splitedString: [String] = chatId.components(separatedBy: "_")
            let senderId: String = splitedString[0]
            let receiverId: String = splitedString[1]
            let childUpdates = [
                "chat/\(chatId)/last_message": last_message,
                "chat/\(chatId)/last_timestamp": Int(trunc(Date().timeIntervalSince1970 * 1000)),
                "chat/\(chatId)/title": chatTitle,
                "user/\(senderId)/chat_list/\(chatId)": "value",
                "user/\(receiverId)/chat_list/\(chatId)": "value",
                "messages/\(chatId)/\(messageUUID)/message": newMessage,
                "messages/\(chatId)/\(messageUUID)/timestamp": Int(trunc(Date().timeIntervalSince1970 * 1000)),
                "messages/\(chatId)/\(messageUUID)/user_uid": senderId,
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
    
    static func removeChat(for chatId: String) {
        let splitedString: [String] = chatId.components(separatedBy: "_")
        let senderId: String = splitedString[1]
        let receiverId: String = splitedString[0]
        
        let childUpdates: [String: Any?] = [
            "/user/\(receiverId)/chat_list/\(chatId)": nil,
            "/user/\(senderId)/chat_list/\(chatId)": nil,
            "/chat/\(chatId)": nil,
            "/messages/\(chatId)": nil
        ]
        
        ref.updateChildValues(childUpdates as [AnyHashable : Any])
    }
}
