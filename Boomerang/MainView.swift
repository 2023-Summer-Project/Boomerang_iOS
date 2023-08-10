//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    @EnvironmentObject var authentication: Authentication
    @Binding var showMainView: Bool
    @State private var notificationCount: Int = 1
    @State private var selectedItem: Int = 0
    @State private var previousSelectedItem: Int = 0
    @State private var showWritePost: Bool = false
    
    var body: some View {
        TabView(selection: $selectedItem) {
            ProductListView(showMainView: $showMainView)
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            SearchView()
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
            
            
            MessageListView()
                .tabItem {
                    Image(systemName: "paperplane.fill")
                }
                .badge(notificationCount)
                .tag(3)
            
            SettingView(showMainView: $showMainView)
                .environmentObject(authentication)
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
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMainView: .constant(true))
            .environmentObject(Authentication())
    }
}
