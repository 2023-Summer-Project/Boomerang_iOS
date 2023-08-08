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
                    print("ChatroomList fetch has been completed.")
                case .failure(let error):
                    print("ChatRoomList fetch error: ", error)
                }
            }, receiveValue: { chatList in
//                variable chatList is the Chat List the User belonging to
//                chatList type - [String: Stirng]
//                chatList ex - [firstChatId: "abcd"]
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
//                            variable chat has Chat Room information such as last message, last_timestamp, title etc
//                            chat type - [String: String]
//                            chat ex - [last_message: "test", last_timestamp: "1690968618738974", title: "테스트"]
                            let chatData: Chat = Chat(id: chatList[key]!, last_message: chat["last_message"]!, last_timestamp: chat["last_timestamp"]!, title: chat["title"]!)
                            self.chatList.append(chatData)
                        })
                        .store(in: &self.cancellables)
                    
                    RealtimeDatabaseModel.fetchMessage(chatList[key]!)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Message fetch has been finished")
                            case .failure(let error):
                                print("Fetching Message Error: " , error)
                            }
                        }, receiveValue: {
//                            parameter type is Message
                            //self.messages[chatList[key]!] = $0
                            if let receiveValue = $0 {
                                if self.messages.keys.contains(chatList[key]!) {
                                    self.messages[chatList[key]!]?.append(receiveValue)
                                } else {
                                    self.messages[chatList[key]!] = [receiveValue]
                                }
                            }
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &self.cancellables)
    }
    
    func uploadNewMessage(message: String, chatId: String) {
        RealtimeDatabaseModel.uploadMessage(newMessage: message, chatId: chatId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //self.fetchUserChat()
                    print("upload new Message has been finished")
                case .failure(let error):
                    print("upload new Message Error: ", error)
                }
            }, receiveValue: {
                print("New Message has been successfully upload")
            })
            .store(in: &self.cancellables)
    }
}
