//
//  SearchView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var authentication: Authentication
    @State private var search: String = ""
    @State private var showTabbar: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fireStoreViewModel.filteredProducts, id: \.self) { product in
                    ZStack {
                        NavigationLink(destination: { ProductDetailView(showTabbar: $showTabbar, product: product)
                                .environmentObject(authentication)
                                .environmentObject(fireStoreViewModel)
                        }, label: {})
                        .opacity(0.0)
                        ProductListRowView(product: product)
                    }
                    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(.plain)
            .searchable(text: $search)
            .onChange(of: search, perform: {
                fireStoreViewModel.searchProducts($0)
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
    }
}
