//
//  EmailStateView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/16.
//

import SwiftUI

struct EmailStateView: View {
    @Binding var emailInputState: EmailInputState
    
    var body: some View {
        switch emailInputState {
        case .empty:
            HStack {
                Image(systemName: "info.circle")
                Text("이메일을 입력하세요.")
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top, 5)
            .font(.footnote)
        case .enabled:
            HStack {
                Image(systemName: "info.circle")
                Text("사용 가능한 이메일입니다.")
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top, 5)
            .font(.footnote)
        case .existed:
            HStack {
                Image(systemName: "info.circle")
                Text("이미 사용 중인 이메일입니다.")
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top, 5)
            .font(.footnote)
            .foregroundColor(.red)
        case .unformed:
            HStack {
                Image(systemName: "info.circle")
                Text("잘못된 형식입니다.")
                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.top, 5)
            .font(.footnote)
            .foregroundColor(.red)
        }
    }
}

struct EmailStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmailStateView(emailInputState: .constant(.empty))
    }
}
