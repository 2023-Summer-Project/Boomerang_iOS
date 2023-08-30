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
            Section(header: Text("약관 및 정책")) {
                NavigationLink(destination: {
                    AppLicenseView()
                }, label: {
                    Text("오픈소스 라이선스")
                })
            }
            
            Section(header: Text("앱 정보")) {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0 (Alpha)")
                }
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
