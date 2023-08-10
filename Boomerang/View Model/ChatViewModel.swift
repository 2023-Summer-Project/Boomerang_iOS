//
//  ChatViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/01.
//

import Combine

final class ChatViewModel: ObservableObject {
    @Published var chatList: Array<Chat> = Array<Chat>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getUserChats()
    }
    
    func getUserChats() {
        //chatList.removeAll()
        
        RealtimeDatabaseModel.fetchChatList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("ChatroomList Fetch completed.")
                case .failure(let error):
                    print("ChatRoomList Fetch error: ", error)
                }
            }, receiveValue: { chatListDictionary in
//                variable chatList is the Chat List the User belonging to
//                chatList type - [String: Stirng]
//                chatList ex - [firstChatId: "abcd"]
                chatListDictionary.keys.forEach { key in
                    RealtimeDatabaseModel.fetchChat(for: chatListDictionary[key]!)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Chat Fetch completed")
                            case .failure(let error):
                                print("Chat Fetch Error: ", error)
                            }
                        }, receiveValue: { [weak self] chat in
//                            variable chat has Chat Room information such as last message, last_timestamp, title etc
//                            chat type - [String: String]
//                            chat ex - [last_message: "test", last_timestamp: "1690968618738974", title: "테스트"]
                            let chatData: Chat = Chat(id: chatListDictionary[key]!, last_message: chat["last_message"]!, last_timestamp: chat["last_timestamp"]!, title: chat["title"]!)
                            
                            self?.chatList.append(chatData)
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &self.cancellables)
    }
}
