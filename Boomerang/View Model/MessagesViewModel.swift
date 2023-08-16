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
        
        if self.chatId != nil {
            getMessages()
        }
    }
}

//MARK: - Messages Fetch
extension MessagesViewModel {
    func getMessages() {
        MessageService.fetchRealtimeMessage(of: chatId!)
            .sink { [weak self] receiveValue in
                //parameter type is Message
                if let receiveValue, let self {
                    if self.messages.keys.contains(chatId!) {
                        self.messages[chatId!]?.append(receiveValue)
                    } else {
                        self.messages[chatId!] = [receiveValue]
                    }
                }
            }
            .store(in: &self.cancellables)
    }
}

//MARK: - Message Upload
extension MessagesViewModel {
    func uploadMessageToExsistingChat(message: String, title: String, timestamp: Int) {
        //upload Message
        MessageService.uploadMessage(newMessage: message, to: chatId!)
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
        
        MessageService.updateChatInfo(getSubString(message), title: title, updateTime: timestamp, to: chatId!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully updated a Chat Info")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                print("update Chat Info")
            })
            .store(in: &self.cancellables)
    }
    
    func uploadMessageToNewChat(from ownerId: String, for productId: String, productTitle: String, message: String) -> String {
        let userId = Auth.auth().currentUser!.uid
        
        chatId = userId + "_" + productId
        
        ChatService.createChat(for: productId, chatTitle: productTitle, last_message: message)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully created a new Chat")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                ChatService.addChatId(self.chatId!, to: ownerId)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("successfully added a new Chat to Owner ChatList")
                        case .failure(let error):
                            print("Error: ", error)
                        }
                    }, receiveValue: {
                        print("add a new Chat to Owner ChatList")
                    })
                    .store(in: &self.cancellables)
                
                ChatService.addChatId(self.chatId!, to: userId)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("successfully added a New Chat to User ChatList")
                        case .failure(let error):
                            print("Error: ", error)
                        }
                    }, receiveValue: {
                        print("add a New Chat to User ChatList")
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
        
        MessageService.uploadMessage(newMessage: message, to: chatId!)
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
        
        return chatId!
    }
    
    private func getSubString(_ message: String) -> String {
        if message.count > 30 {
            let startIndex = message.startIndex
            let lastIndex = message.index(startIndex, offsetBy: 29)
            
            return String(message[startIndex...lastIndex]) + "..."
        } else {
            return message
        }
    }
}
