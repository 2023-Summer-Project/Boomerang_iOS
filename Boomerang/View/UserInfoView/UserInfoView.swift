//
//  UserInfoView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI
import FirebaseAuth

struct UserInfoView: View {
    var body: some View {
        if let user = Auth.auth().currentUser {
            Text(user.email!)
        } else {
            EmptyView()
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
