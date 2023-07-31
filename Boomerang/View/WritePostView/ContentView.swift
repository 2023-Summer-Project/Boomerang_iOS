//
//  IntroductionView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var content: String
    
    var body: some View {
        VStack {
            HStack {
                Text("물건 소개")
                Spacer()
            }
            
            TextField("물건에 대한 소개를 작성해 주세요.", text: $content)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.bottom, 15)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(content: .constant(""))
    }
}
