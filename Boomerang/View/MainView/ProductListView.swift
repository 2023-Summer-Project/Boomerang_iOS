//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var fireStore: FireStore = FireStore()
    @EnvironmentObject var authentication: Authentication
    @State var search: String = ""
    @State var showWritePost: Bool = false
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fireStore.products, id: \.self) { product in
                    ZStack {
                        NavigationLink(destination: { ProductDetailView(product: product) }, label: {})
                            .opacity(0.0)
                        ProductListRowView(product: product)
                    }
                    .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $showWritePost, content: {
                EmptyView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: { NotificationView() }, label: { Image(systemName: "bell") })
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar, content: {
                    Spacer()
                    
                    Button(action: { showWritePost = true }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    })
                })
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(showMainView: .constant(true))
            .environmentObject(Authentication())
    }
}
