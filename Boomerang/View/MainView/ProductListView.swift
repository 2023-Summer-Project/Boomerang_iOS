//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var fireStore: FireStore
    @EnvironmentObject var authentication: Authentication
    @State var search: String = ""
    @State var showWritePostView: Bool = false
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fireStore.products, id: \.0) { product in
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
            .sheet(isPresented: $showWritePostView, content: {
                WritePostView(showWritePostView: $showWritePostView)
                    .environmentObject(fireStore)
                    .environmentObject(authentication)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: { NotificationView() }, label: {
                        Image(systemName: "bell.fill")
                    })
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar, content: {
                    Spacer()

                    Button(action: { showWritePostView = true }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 45))
                    })
                    .padding(.bottom, 30)
                    .padding(.trailing, -10)
                })
            }
            .refreshable {
                //아래로 당겨서 refresh
                fireStore.fetchProduct()
            }
        }
        .onAppear {
            UIToolbar.changeAppearance(clear: true)
        }
    }
}

extension UIToolbar {
    static func changeAppearance(clear: Bool) {
        let appearance = UIToolbarAppearance()
        
        if clear {
            appearance.configureWithOpaqueBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }
        
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        
        UIToolbar.appearance().standardAppearance = appearance
        UIToolbar.appearance().compactAppearance = appearance
        UIToolbar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(showMainView: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(FireStore())
    }
}
