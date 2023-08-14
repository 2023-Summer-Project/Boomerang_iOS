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
        MessageModel.fetchRealtimeMessage(of: chatId!)
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
        MessageModel.uploadMessage(newMessage: message, to: chatId!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished uploading New Message")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                print("upload New Message")
            })
            .store(in: &self.cancellables)
        
        MessageModel.updateChatInfo(message, title: title, updateTime: timestamp, to: chatId!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished updating Chat Info")
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
        
        ChatModel.createChat(for: productId, chatTitle: productTitle, last_message: message)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished creating a new Chat")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                ChatModel.addChatId(self.chatId!, to: ownerId)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("finished adding a new Chat to Owner ChatList")
                        case .failure(let error):
                            print("Error: ", error)
                        }
                    }, receiveValue: {
                        print("add a new Chat to Owner ChatList")
                    })
                    .store(in: &self.cancellables)

                ChatModel.addChatId(self.chatId!, to: userId)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("finished adding a New Chat to User ChatList")
                        case .failure(let error):
                            print("Error: ", error)
                        }
                    }, receiveValue: {
                        print("add a New Chat to User ChatList")
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
        
        MessageModel.uploadMessage(newMessage: message, to: chatId!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished uploading a New Message")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                print("upload New Message")
            })
            .store(in: &self.cancellables)
        
        return chatId!
    }
}
