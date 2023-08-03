//
//  RealtimeDatabaseViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//

import Combine

final class RealtimeDatabaseViewModel: ObservableObject {
    @Published var chatList: Array<Chat> = Array<Chat>()
    @Published var messages: Dictionary<String, [Message]> = Dictionary<String, [Message]>()
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchUserChat()
    }
    
    func fetchUserChat() {
        chatList = []
        
        RealtimeDatabaseModel.fetchChatList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("ChatroomList fetch has been completed.")
                case .failure(let error):
                    print("ChatRoomList fetch error: ", error)
                }
            }, receiveValue: { chatList in
                chatList.keys.forEach { key in
                    RealtimeDatabaseModel.fetchChat(chatId: chatList[key]!)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Chat fetch has been completed")
                            case .failure(let error):
                                print("Chat fetch Error: ", error)
                            }
                        }, receiveValue: { chat in
                            let chatData: Chat = Chat(id: chatList[key]!, last_message: chat["last_message"]!, last_timestamp: chat["last_timestamp"]!, title: chat["title"]!)
                            self.chatList.append(chatData)
                        })
                        .store(in: &self.cancellable)
                    
                    RealtimeDatabaseModel.fetchMessage(chatList[key]!)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Message fetch has been finished")
                            case .failure(let error):
                                print("Fetching Message Error: " , error)
                            }
                        }, receiveValue: {
                            self.messages[chatList[key]!] = $0
                        })
                        .store(in: &self.cancellable)
                }
            })
            .store(in: &self.cancellable)
    }
}
