//
//  InfoView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/31.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        HStack {
            Text("이미지는 5장까지 등록 가능합니다.")
            Spacer()
        }
        .foregroundColor(.gray)
        .font(.footnote)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
