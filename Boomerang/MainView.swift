//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    @StateObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel()
    @StateObject var authentication: Authentication = Authentication()
    @StateObject var userInfoViewModel: UserInfoViewModel = UserInfoViewModel()
    @State private var notificationCount: Int = 1
    @State private var selectedItem: Int = 0
    @State private var previousSelectedItem: Int = 0
    @State private var showWritePost: Bool = false
    @State private var showMessageDetail: Bool = false
    @State private var showExistingMessageDetail: Bool = false
    @State private var selectedProduct: Product?
    @Binding var showMainView: Bool
    
    var body: some View {
        TabView(selection: $selectedItem) {
            ProductListView(selectedItem: $selectedItem, showMessageDetail: $showMessageDetail, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct)
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            SearchView(selectedItem: $selectedItem, showMessageDetail: $showMessageDetail, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct)
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            Text("")
                .tabItem {
                    Image(systemName: "plus.app.fill")
                }
                .tag(2)
            
            MessageListView(showMessageDetail: $showMessageDetail, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .tabItem {
                    Image(systemName: "paperplane.fill")
                }
                .badge(notificationCount)
                .tag(3)
            
            MyPageView(showMainView: $showMainView)
                .environmentObject(authentication)
                .environmentObject(userInfoViewModel)
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
        .sheet(isPresented: $showWritePost, content: {
            WritePostView(showWritePost: $showWritePost)
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
        })
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMainView: .constant(true))
            .environmentObject(UserInfoViewModel())
    }
}
