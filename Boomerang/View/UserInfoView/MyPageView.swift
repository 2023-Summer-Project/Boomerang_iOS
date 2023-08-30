//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showMainView: Bool
    @Binding var selectedItem: Int
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List {
            UserInfoView(userInfo: $userInfoViewModel.userInfo)
                .listRowSeparator(.hidden)
            
            Section(header: Text("내 거래"), content: {
                NavigationLink(destination: {
                    ProgressingTransactionView()
                        .environmentObject(transactionViewModel)
                }, label: {
                    Text("진행 중인 거래")
                        .padding([.top, .bottom], 10)
                })
                
                NavigationLink(destination: {
                    CompletionTransectionListView(transactions: transactionViewModel.completionTransactions)
                        .environmentObject(transactionViewModel)
                }, label: {
                    Text("완료한 거래")
                        .padding([.top, .bottom], 10)
                })
            })
            
            Section(header: Text("내 물건"), content: {
                NavigationLink(destination: {
                    ProductListView(selectedItem: $selectedItem, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct, products: productViewModel.userProducts)
                        .environmentObject(authentication)
                        .environmentObject(productViewModel)
                        .environmentObject(chatViewModel)
                        .environmentObject(userInfoViewModel)
                        .environmentObject(transactionViewModel)
                }, label: {
                    Text("내가 등록한 물건")
                        .padding([.top, .bottom], 10)
                })
            })
            
            Section(header: Text("로그인 관리"), content: {
                Button(action: {
                    authentication.signOut()
                    showMainView = false
                }, label: {
                    Text("로그아웃")
                        .foregroundColor(.red)
                        .padding([.top, .bottom], 10)
                })
            })
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top) {
            VStack {
                HStack {
                    Text("내 정보")
                    
                    Spacer()
                    
                    NavigationLink(destination: {
                        SettingView()
                    }, label: {
                        Image(systemName: "gearshape.fill")
                    })
                }
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width)
            }
            .padding([.leading, .top, .trailing])
            .bold()
            .font(.title2)
            .background(colorScheme == .light ? .white : .black)
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showMainView: .constant(true), selectedItem: .constant(1), showExistingMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(ChatViewModel())
            .environmentObject(ProductViewModel())
            .environmentObject(Authentication())
            .environmentObject(UserInfoViewModel())
            .environmentObject(TransactionViewModel())
    }
}
