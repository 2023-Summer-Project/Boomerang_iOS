//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @Binding var showSettingView: Bool
    @Binding var showMainView: Bool
    
    var body: some View {
        List {
            Section(header: Text("회원정보 관리"), content: {
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                    
                    showSettingView = false
                    showMainView = false
                }, label: {
                    Text("로그아웃")
                        .foregroundColor(.red)
                })
            })
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showSettingView: .constant(true), showMainView: .constant(true))
    }
}
