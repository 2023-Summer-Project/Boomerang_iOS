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
    @State private var search: String = ""
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fireStore.products, id: \.self) { product in
                    ZStack {
                        NavigationLink(destination: { ProductDetailView(product: product)
                                .environmentObject(authentication)
                                .environmentObject(fireStore)
                        }, label: {})
                        .opacity(0.0)
                        ProductListRowView(product: product)
                            .environmentObject(fireStore)
                    }
                    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(.plain)
            .toolbarColorScheme(.light, for: .bottomBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: { NotificationView() }, label: {
                        Image(systemName: "bell.fill")
                    })
                }
            }
            .refreshable {
                //아래로 당겨서 refresh
                fireStore.fetchProduct()
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(showMainView: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
    }
}
