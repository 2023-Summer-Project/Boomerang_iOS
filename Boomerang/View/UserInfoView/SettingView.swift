//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/18.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            HStack {
                Text("버전 정보: ")
                Spacer()
                Text("1.0 (Alpha)")
            }
        }
        .navigationTitle("설정")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
