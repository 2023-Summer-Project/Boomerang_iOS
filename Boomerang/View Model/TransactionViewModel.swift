//
//  TransactionViewModel.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/27.
//

import Combine
import FirebaseAuth

enum TransactionResult {
    case success
    case fail
}

final class TransactionViewModel: ObservableObject {
    @Published var requestedTransactions: [Transaction] = []
    @Published var sentTransactions: [Transaction] = []
    @Published var completionTransactions: [Transaction] = []
    @Published var showTransactionAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    var result: TransactionResult = .fail
    
    init() {
        getSentTransaction()
        getRequestedTransaction()
        getCompletedTransaction()
    }
    
    func getSentTransaction() {
        FireStoreService.fetchRequestedTransaction(role: "RENTEE", status: "REQUESTED", "ACCEPTED", "REJECTED")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfullt get Sent Transaction")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                self.sentTransactions = $0 ?? []
            })
            .store(in: &cancellables)
    }
    
    func getRequestedTransaction() {
        FireStoreService.fetchRequestedTransaction(role: "RENTER", status: "REQUESTED", "ACCEPTED", "REJECTED")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully got Requested Transaction")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                self.requestedTransactions = $0 ?? []
            })
            .store(in: &cancellables)
    }
    
    func getCompletedTransaction() {
        FireStoreService.fetchCompletedTransaction(status: "COMPLETED")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully got COmpletion Transaction")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                self.completionTransactions = $0 ?? []
            })
            .store(in: &cancellables)
    }
    
    func createTransaction(_ product: Product, _ price: Int, startDate: Date, endDate: Date) {
        let docData: [String: Any] = [
            "DEPOSIT": 0,
            "END_DATE": endDate,
            "LOCATION": product.LOCATION,
            "PRICE": price,
            "PRODUCT_ID": product.id,
            "RENTEE": Auth.auth().currentUser?.uid ?? "",
            "RENTER": product.OWNER_ID,
            "START_DATE": startDate,
            "STATUS": "REQUESTED",
            "PRODUCT_IMAGE": product.IMAGES_MAP[product.IMAGE_MAP_KEYS[0]]!,
            "PRODUCT_NAME": product.PRODUCT_NAME
        ]
        
        FireStoreService.createTransaction(docData)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Transaction Document successfully written!")
                    self.result = .success
                    self.showTransactionAlert = true
                case .failure(let error):
                    print("Error: ", error)
                    self.result = .fail
                    self.showTransactionAlert = true
                }
            }, receiveValue: {
                print("create Transaction")
            })
            .store(in: &cancellables)
    }
    
    func updateTransactionStatus(transactionId: String, change: String) {
        FireStoreService.updateTransactionStatus(of: transactionId, status: change)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Transaction Status successfully updated")
                case .failure(let error):
                    print("Error: ", error)
                }
            }, receiveValue: {
                print("Transaction Status update")
            })
            .store(in: &cancellables)
    }
}
