//
//  SearchView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var fireStore: FireStore
    @EnvironmentObject var authentication: Authentication
    @State var search: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fireStore.filteredProducts, id: \.0) { product in
                    ZStack {
                        NavigationLink(destination: { ProductDetailView(product: product)
                                .environmentObject(authentication)
                                .environmentObject(fireStore)
                        }, label: {})
                            .opacity(0.0)
                        ProductListRowView(product: product)
                    }
                    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $search)
        .onChange(of: search, perform: {
            fireStore.searchProducts($0)
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Authentication())
            .environmentObject(FireStore())
    }
}
