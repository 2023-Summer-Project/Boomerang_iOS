//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    @StateObject var productViewModel: ProductViewModel = ProductViewModel()
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel()
    @StateObject var authentication: Authentication = Authentication()
    @StateObject var userInfoViewModel: UserInfoViewModel = UserInfoViewModel()
    @StateObject var transactionViewModel: TransactionViewModel = TransactionViewModel()
    @State private var notificationCount: Int = 0
    @State private var selectedItem: Int = 0
    @State private var previousSelectedItem: Int = 0
    @State private var showWritePost: Bool = false
    @State private var showExistingMessageDetail: Bool = false
    @State private var selectedProduct: Product?
    @Binding var showMainView: Bool
    
    var body: some View {
        TabView(selection: $selectedItem) {
            ProductListView(selectedItem: $selectedItem, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct, products: productViewModel.products)
                .environmentObject(authentication)
                .environmentObject(productViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .environmentObject(transactionViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            SearchView(selectedItem: $selectedItem, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct)
                .environmentObject(authentication)
                .environmentObject(productViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .environmentObject(transactionViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            Text("")
                .tabItem {
                    Image(systemName: "plus.app.fill")
                }
                .tag(2)
            
            MessageListView(selectedProduct: $selectedProduct)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .tabItem {
                    Image(systemName: "paperplane.fill")
                }
                .badge(notificationCount)
                .tag(3)
            
            MyPageView(showMainView: $showMainView, selectedItem: $selectedItem, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct)
                .environmentObject(chatViewModel)
                .environmentObject(productViewModel)
                .environmentObject(authentication)
                .environmentObject(userInfoViewModel)
                .environmentObject(transactionViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
        .onChange(of: selectedItem) { value in
            if value == 2 {
                selectedItem = previousSelectedItem
                showWritePost = true
            } else {
                previousSelectedItem = value
            }
        }
        .fullScreenCover(isPresented: $showWritePost, content: {
            NavigationStack {
                WritePostView(showWritePost: $showWritePost)
                    .environmentObject(authentication)
                    .environmentObject(productViewModel)
                    .environmentObject(userInfoViewModel)
            }
        })
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showExistingMessageDetail, destination: {
            MessageDetailView(messagesViewModel: MessagesViewModel(for: getChatIdFromSelectedProduct(selectedProduct)), selectedProduct: $selectedProduct, messageTitle: selectedProduct?.PRODUCT_NAME ?? "")
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMainView: .constant(true))
            .environmentObject(UserInfoViewModel())
    }
}
