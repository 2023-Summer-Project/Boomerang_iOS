//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var fireStore: FireStoreViewModel
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var search: String = ""
    @Binding var selectedItem: Int
    @Binding var showMessageDetail: Bool
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List {
            ForEach(fireStore.products, id: \.self) { product in
                ZStack {
                    NavigationLink(destination: { ProductDetailView(showMessageDetail: $showMessageDetail, showExistingMessageDetail: $showExistingMessageDetail, selectedItem: $selectedItem, selectedProduct: $selectedProduct, product: product)
                            .environmentObject(authentication)
                            .environmentObject(fireStore)
                            .environmentObject(chatViewModel)
                            .environmentObject(userInfoViewModel)
                    }, label: {})
                    .opacity(0.0)
                    ProductListRowView(product: product)
                        .environmentObject(fireStore)
                }
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .safeAreaInset(edge: .top, content: {
            HStack {
                Text("둘러보기")
                    .bold()
                Spacer()
                
                NavigationLink(destination: {
                    NotificationView()
                }, label: {
                    Image(systemName: "bell.fill")
                })
            }
            .font(.title2)
            .padding()
            .background(colorScheme == .light ? .white : .black)
        })
        .refreshable {
            //아래로 당겨서 refresh
            fireStore.fetchProduct()
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(selectedItem: .constant(1), showMessageDetail: .constant(false), showExistingMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
            .environmentObject(ChatViewModel())
            .environmentObject(UserInfoViewModel())
    }
}
