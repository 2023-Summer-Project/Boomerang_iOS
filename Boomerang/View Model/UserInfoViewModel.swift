//
//  UserInfoViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/16.
//

import Combine

final class UserInfoViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getUserInfo()
    }
    
    func getUserInfo() {
        UserInfoService.fetchUserInfo()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully fetched User Info")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: { userInfo in
                if case .some(let wrapped) = userInfo {
                    self.userInfo = wrapped
                }
            })
            .store(in: &cancellables)
    }
    
    func uploadUserInfo(_ email: String, _ userName: String) {
        UserInfoService.uploadUserInfo(email: email, userName: userName)
    }
}
