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
    @Environment(\.colorScheme) private var colorScheme
    @State private var search: String = ""
    @Binding var showTabbar: Bool
    @Binding var showMainView: Bool
    @Binding var selectedItem: Int
    @Binding var showMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List {
            ForEach(fireStore.products, id: \.self) { product in
                ZStack {
                    NavigationLink(destination: { ProductDetailView(showMessageDetail: $showMessageDetail, showTabbar: $showTabbar, selectedItem: $selectedItem, selectedProduct: $selectedProduct, product: product)
                            .environmentObject(authentication)
                            .environmentObject(fireStore)
                            .environmentObject(chatViewModel)
                    }, label: {})
                    .opacity(0.0)
                    ProductListRowView(product: product)
                        .environmentObject(fireStore)
                }
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top, content: {
            HStack {
                Text("둘러보기")
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
            }
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
        ProductListView(showTabbar: .constant(true), showMainView: .constant(true), selectedItem: .constant(1), showMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
            .environmentObject(ChatViewModel())
    }
}
