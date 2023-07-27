//
//  TitleView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/26.
//

import SwiftUI

struct TitleView: View {
    @Binding var title: String
    
    var body: some View {
        VStack {
            HStack {
                Text("제목")
                Spacer()
            }
            TextField("제목을 입력해 주세요.", text: $title)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.bottom, 10)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: .constant(""))
    }
}
