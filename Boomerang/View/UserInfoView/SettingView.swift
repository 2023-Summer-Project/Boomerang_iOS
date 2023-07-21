//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authentication: Authentication
    @Binding var showMainView: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("계정 정보 확인"), content: {
                    NavigationLink(destination: { UserInfoView() }, label: { Text("내 정보 확인") })
                })
                
                Section(header: Text("로그인 관리"), content: {
                    Button(action: {
                        authentication.signOut()
                        showMainView = false
                    }, label: {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    })
                })
            }
            .navigationTitle("내 정보")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showMainView: .constant(true))
            .environmentObject(Authentication())
    }
}