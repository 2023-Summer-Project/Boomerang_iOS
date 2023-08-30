//
//  RequestedTransectionListView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/16.
//

import SwiftUI

struct ProgressingTransactionListView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    var transactions: [Transaction]
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                TransactionListRowView(transaction: transaction)
                    .environmentObject(transactionViewModel)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("진행 중인 거래")
    }
}

struct ProgressingTransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressingTransactionListView(transactions: [])
            .environmentObject(TransactionViewModel())
    }
}
