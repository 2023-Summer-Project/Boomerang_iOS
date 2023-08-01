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
    @State private var notificationCount: Int = 99
    @State private var selectedItem: Int = 0
    @State private var previousSelectedItem: Int = 0
    @State private var showWritePost: Bool = false
    
    var body: some View {
        TabView(selection: $selectedItem) {
            ProductListView(showMainView: $showMainView)
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Label("홈", systemImage: "house")
                }
                .tag(0)
            
            SearchView()
                .environmentObject(authentication)
                .environmentObject(fireStoreViewModel)
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            Text("")
                .tabItem {
                    Label("등록", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            
            MessageListView()
                .tabItem {
                    Label("채팅", systemImage: "paperplane.fill")
                }
                .badge(notificationCount)
                .tag(3)
            
            SettingView(showMainView: $showMainView)
                .environmentObject(authentication)
                .tabItem {
                    Label("내정보", systemImage: "person.fill")
                }
                .tag(4)
        }
        .onChange(of: selectedItem) { value in
            if value == 2 {
                showWritePost = true
            } else {
                previousSelectedItem = value
            }
        }
        .sheet(isPresented: $showWritePost, onDismiss: {
            selectedItem = previousSelectedItem
        }, content: {
            WritePostView()
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
