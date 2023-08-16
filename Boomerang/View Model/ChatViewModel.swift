//
//  ChatViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//

import Combine
import FirebaseAuth

final class ChatViewModel: ObservableObject {
    @Published var chatList: Array<Chat> = Array<Chat>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getUserChatList()
    }
}

extension ChatViewModel {
    //MARK: - User Chat Fetch
    func getUserChatList() {
        ChatService.fetchChatList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully fetched the Chat List")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: { [weak self] chatId in
                if let chatId {
                    ChatService.fetchChat(for: chatId)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("successfully fetched a Chat")
                            case .failure(let error):
                                print("Error: ", error)
                            }
                        }, receiveValue: { [weak self] chat in
                            if case .some(let value) = chat {
                                var isExist: Bool = false
                                
                                for i in 0..<self!.chatList.count {
                                    if self?.chatList[i].id == value.id {
                                        self?.chatList[i] = value
                                        isExist = true
                                        break
                                    }
                                }
                                
                                if !isExist {
                                    self?.chatList.append(value)
                                }
                            }
                        })
                        .store(in: &self!.cancellables)
                }
            })
            .store(in: &self.cancellables)
    }
}

extension ChatViewModel {
    //MARK: - Check Chat existence
    func isExist(_ productId: String) -> Bool {
        var result: Bool = false
        
        chatList.forEach { chat in
            if chat.id.contains(productId) {
                result = true
            }
        }
        
        return result
    }
}

extension ChatViewModel {
    func removeChat(for chat: Chat) {
        ChatService.removeChat(for: chat.id)
        
        //remove Chat of local chat list
        for i in 0..<chatList.count {
            if chatList[i].id == chat.id {
                chatList.remove(at: i)
                break
            }
        }
    }
}

func getChatIdOfSelectedProduct(_ productId: String?) -> String? {
    if case .some(let value) = productId {
        return Auth.auth().currentUser!.uid + "_" + value
    }

    return nil
}
