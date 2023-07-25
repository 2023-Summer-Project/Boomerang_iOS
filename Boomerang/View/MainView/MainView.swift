//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var fireStore: FireStore = FireStore()
    @EnvironmentObject var authentication: Authentication
    @Binding var showMainView: Bool
    @State var notificationCount: Int = 99
    
    var body: some View {
        TabView {
            ProductListView(showMainView: $showMainView)
                .environmentObject(authentication)
                .environmentObject(fireStore)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            SearchView()
                .environmentObject(authentication)
                .environmentObject(fireStore)
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("검색")
                }
            
            MessageListView()
                .tabItem {
                    Image(systemName: "paperplane.fill")
                    Text("채팅")
                }
                .badge(notificationCount)
            
            SettingView(showMainView: $showMainView)
                .environmentObject(authentication)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("내 정보")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMainView: .constant(true))
            .environmentObject(Authentication())
    }
}
