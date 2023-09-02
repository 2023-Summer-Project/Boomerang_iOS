//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedItem: Int
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var products: [Product]
    
    var body: some View {
        List {
            ForEach(products) { product in
                ZStack {
                    NavigationLink(destination: {
                        ProductDetailView(showExistingMessageDetail: $showExistingMessageDetail, selectedItem: $selectedItem, selectedProduct: $selectedProduct, product: product)
                            .environmentObject(authentication)
                            .environmentObject(productViewModel)
                            .environmentObject(chatViewModel)
                            .environmentObject(userInfoViewModel)
                            .environmentObject(transactionViewModel)
                    }, label: {})
                    .opacity(0.0)
                    ProductListRowView(product: product)
                        .environmentObject(productViewModel)
                }
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            }
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top, content: {
            if selectedItem == 0 {
                VStack {
                    HStack {
                        Text("둘러보기")
                            .padding([.leading, .top])
                            .bold()
                        Spacer()
                        
                        NavigationLink(destination: {
                            NotificationView()
                        }, label: {
                            Image(systemName: "bell.fill")
                                .padding([.trailing])
                        })
                    }
                    Divider()
                        .frame(width: UIScreen.main.bounds.width)
                }
                .font(.title2)
                .background(colorScheme == .light ? .white : .black)
            }
        })
        .refreshable {
            //아래로 당겨서 refresh
            if selectedItem == 0 {
                productViewModel.getProduct()
            } else if selectedItem == 4 {
                productViewModel.getUserProduct()
            }
        }
        .navigationTitle("내가 등록한 물건")
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(selectedItem: .constant(1), showExistingMessageDetail: .constant(false), selectedProduct: .constant(nil), products: [])
            .environmentObject(Authentication())
            .environmentObject(ProductViewModel())
            .environmentObject(ChatViewModel())
            .environmentObject(UserInfoViewModel())
    }
}
