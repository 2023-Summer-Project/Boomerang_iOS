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
        VStack(alignment: .leading) {
            Text("물건 소개")
                .bold()
            
            TextField("물건에 대한 소개를 작성해 주세요.", text: $content, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5, reservesSpace: true)
        }
        .padding(.bottom, 10)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(content: .constant(""))
    }
}
