//
//  CompletionTransectionListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/16.
//

import SwiftUI

struct CompletionTransectionListView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    var transactions: [Transaction]
    
    var body: some View {
        if transactions.isEmpty {
            Text("완료한 거래가 존재하지 않습니다 :(")
                .font(.title3)
                .foregroundColor(.gray)
                .navigationTitle("완료한 거래")
        } else {
            List {
                ForEach(transactions) {
                    TransactionListRowView(transaction: $0)
                        .environmentObject(transactionViewModel)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("완료한 거래")
        }
    }
}

struct CompletionTransectionListView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionTransectionListView(transactions: [])
            .environmentObject(TransactionViewModel())
    }
}
