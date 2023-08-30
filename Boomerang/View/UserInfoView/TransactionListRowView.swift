//
//  ProgressingTransactionListRowView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TransactionListRowView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @State private var showDenyAlert: Bool = false
    @State private var showCompletionAlert: Bool = false
    @State private var showAcceptionAlert: Bool = false
    
    var transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading) {
            if transaction.STATUS == .required {
                Text("요청됨")
                    .font(.title3)
                    .bold()
            } else if transaction.STATUS == .accepted {
                Text("수락됨")
                    .font(.title3)
                    .bold()
            } else if transaction.STATUS == .rejected {
                Text("거절됨")
                    .font(.title3)
                    .bold()
            } else if transaction.STATUS == .completed {
                Text("완료됨")
                    .font(.title3)
                    .bold()
            }
            
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: transaction.PRODUCT_IMAGE)) { image in
                    image
                        .resizable()
                        .frame(width: 70.0, height: 70.0)
                        .cornerRadius(15)
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 209 / 255, green: 209 / 255, blue: 209 / 255))
                        ProgressView()
                    }
                    .frame(width: 70.0, height: 70.0)
                    .cornerRadius(15)
                }
                
                VStack(alignment: .leading) {
                    Text(transaction.PRODUCT_NAME)
                        .font(.title3)
                    
                    Text("\(transaction.START_DATE.dateValue().getDayFormat())부터  \(transaction.END_DATE.dateValue().getDayFormat())까지")
                        .font(.system(size: 13))
                }
                
                Spacer()
            }
            
            if transaction.STATUS == .required && transaction.RENTER == Auth.auth().currentUser?.uid {
                HStack {
                    Button(action: {
                        showDenyAlert = true
                    }, label: {
                        Text("요청 거절")
                            .padding(6)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(10)
                    })
                    .buttonStyle(.borderless)
                    .alert(isPresented: $showDenyAlert) {
                        Alert(title: Text("알림"), message: Text("해당 거래를 거절 할까요?"), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("거절"), action: {
                            transactionViewModel.updateTransactionStatus(transactionId: transaction.id, change: "REJECTED")
                        }))
                    }
                    
                    Button(action: {
                        showAcceptionAlert = true
                    }, label: {
                        Text("요청 수락")
                            .padding(6)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.indigo)
                            .cornerRadius(10)
                    })
                    .buttonStyle(.borderless)
                    .alert(isPresented: $showAcceptionAlert) {
                        Alert(title: Text("알림"), message: Text("해당 거래를 수락 할까요?"), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("수락"), action: {
                            transactionViewModel.updateTransactionStatus(transactionId: transaction.id, change: "ACCEPTED")
                        }))
                    }
                }
            } else if transaction.STATUS == .rejected || transaction.STATUS == .accepted {
                Button(action: {
                    showCompletionAlert = true
                }, label: {
                    Text("거래 완료")
                        .padding(6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.indigo)
                        .cornerRadius(10)
                })
                .buttonStyle(.borderless)
                .alert(isPresented: $showCompletionAlert) {
                    Alert(title: Text("알림"), message: Text("해당 거래를 완료 할까요?"), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("완료"), action: {
                        transactionViewModel.updateTransactionStatus(transactionId: transaction.id, change: "COMPLETED")
                    }))
                }
            } else if transaction.STATUS == .required {
                Text("요청을 기다리는 중이에요")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            } else if transaction.RENTEE == Auth.auth().currentUser?.uid && transaction.STATUS == .accepted {
                Text("요청이 수락 되었습니다.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            } else if transaction.STATUS == .completed {
                Text("거래가 종료 되었습니다.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct TransactionListRowView_Preview: PreviewProvider {
    static var previews: some View {
        TransactionListRowView(transaction: Transaction(id: "", DEPOSIT: 0, END_DATE: Timestamp(date: Date()), LOCATION: "용인시 동백동", PRICE: 0, PRODUCT_ID: "", PRODUCT_NAME: "테스트", RENTEE: "", RENTER: "", START_DATE: Timestamp(date: Date()), STATUS: .required, PRODUCT_IMAGE: "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/2023_summer_project.png?alt=media&token=692ddad2-7b3f-4b5d-b5aa-507a9d994d97"))
            .environmentObject(TransactionViewModel())
    }
}
