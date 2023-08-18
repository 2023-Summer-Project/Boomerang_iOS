//
//  MessagesViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/10.
//

import Combine
import FirebaseAuth

final class MessagesViewModel: ObservableObject {
    @Published var messages: Dictionary<String, [Message]> = Dictionary<String, [Message]>()
    
    private var cancellables = Set<AnyCancellable>()
    
    var chatId: String? {
        didSet {
            getMessages()
        }
    }
    
    init(for chatId: String?) {
        self.chatId = chatId

        getMessages()
    }
}

//MARK: - Messages Fetch
extension MessagesViewModel {
    func getMessages() {
        if let chatId = chatId {
            MessagesService.fetchRealtimeMessage(of: chatId)
                .sink { [weak self] receiveValue in
                    //parameter type is Message
                    if let receiveValue, let self {
                        if self.messages.keys.contains(chatId) {
                            self.messages[chatId]?.append(receiveValue)
                        } else {
                            self.messages[chatId] = [receiveValue]
                        }
                    }
                }
                .store(in: &self.cancellables)
        }
    }
}

//MARK: - Message Upload
extension MessagesViewModel {
    func uploadMessageToExsistingChat(message: String, title: String, timestamp: Int, userName: String) {
        //upload Message
        if let chatId = chatId {
            MessagesService.uploadMessage(newMessage: message, chatTitle: title, updateTime: timestamp, senderName: userName ,to: chatId)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("successfully uploaded a New Message")
                    case .failure(let error):
                        print("Error: ", error)
                    }
                }, receiveValue: {
                    print("upload New Message")
                })
                .store(in: &self.cancellables)
        }
    }
    
    func uploadMessageToNewChat(from ownerId: String, for productId: String, productTitle: String, message: String, userName: String) {
        let userId = Auth.auth().currentUser!.uid
        
        chatId = userId + "_" + ownerId + "_" + productId
        
        ChatService.createChat(for: chatId!, chatTitle: productTitle, last_message: message, newMessage: message, senderName: userName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully created a new Chat")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                print("create new chat")
            })
            .store(in: &cancellables)
    }
}
