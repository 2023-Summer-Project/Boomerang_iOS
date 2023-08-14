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
        ChatModel.fetchChatList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("completed fetching the Chat List")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: { [weak self] chatId in
                if let chatId {
                    ChatModel.fetchChat(for: chatId)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("completed fetching Chat")
                            case .failure(let error):
                                print("Error: ", error)
                            }
                        }, receiveValue: { [weak self] chat in
                            self?.chatList.append(chat)
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
    //MARK: - update local Chat Info
    func updateLocalChatInfo(_ message: String ,timestamp: Int, for chatId: String) {
        for i in 0..<chatList.count {
            if chatList[i].id == chatId {
                chatList[i].last_message = message
                chatList[i].last_timestamp = timestamp
                break
            }
        }
    }
}
