//
//  ProgressingTransactionView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/28.
//

import SwiftUI

enum TapInfo: String, CaseIterable {
    case requested = "받은 거래"
    case sent = "보낸 거래"
}

struct ProgressingTransactionView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @State private var selectedPicker: TapInfo = .requested
    @Namespace private var animation
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                HStack {
                    ForEach(TapInfo.allCases, id: \.self) { item in
                        VStack {
                            Text(item.rawValue)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedPicker == item ? .black : .gray)
                            
                            if selectedPicker == item {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(.indigo)
                                    .matchedGeometryEffect(id: "underline", in: animation)
                            } else {
                                Color.clear.frame(height: 3)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedPicker = item
                            }
                        }
                    }
                }
                
                Divider()
            }
            
            if selectedPicker == .requested {
                ProgressingTransactionListView(transactions: transactionViewModel.requestedTransactions)
                    .environmentObject(transactionViewModel)
            } else {
                ProgressingTransactionListView(transactions: transactionViewModel.sentTransactions)
                    .environmentObject(transactionViewModel)
            }
        }
    }
}

struct ProgressingTransactionView_Preview: PreviewProvider {
    static var previews: some View {
        ProgressingTransactionView()
            .environmentObject(TransactionViewModel())
    }
}
