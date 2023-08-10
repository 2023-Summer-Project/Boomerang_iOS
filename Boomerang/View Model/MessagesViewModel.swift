//
//  MessagesViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/10.
//

import Combine

final class MessagesViewModel: ObservableObject {
    @Published var messages: Dictionary<String, [Message]> = Dictionary<String, [Message]>()
    
    private var cancellables = Set<AnyCancellable>()
    private var chatId: String
    
    init(for chatId: String) {
        self.chatId = chatId
        
        getMessages()
    }
}

//MARK: - Messages Fetch
extension MessagesViewModel {
    func getMessages() {
        RealtimeDatabaseModel.fetchRealtimeMessage(for: chatId)
            .sink { [weak self] receiveValue in
                //parameter type is Message
                if let receiveValue, let self {
                    if self.messages.keys.contains(chatId) {
                        self.messages[chatId]?.append(receiveValue)
                    } else {
                        self.messages[chatId] = [receiveValue]
                    }
                }
            }.store(in: &self.cancellables)
    }
}

//MARK: - Message Upload
extension MessagesViewModel {
    func uploadNewMessage(message: String) {
        RealtimeDatabaseModel.uploadMessage(newMessage: message, to: chatId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //self.fetchUserChat()
                    print("New Message Upload finished")
                case .failure(let error):
                    print("New Message Upload Error: ", error)
                }
            }, receiveValue: {
                print("A New Message has been successfully uploaded")
            })
            .store(in: &self.cancellables)
    }
}
