//
//  PriceView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/26.
//

import SwiftUI

struct PriceView: View {
    @Binding var price: String
    
    var body: some View {
        VStack {
            HStack {
                Text("가격")
                Spacer()
            }
            HStack {
                TextField("가격은 얼마 인가요?", text: $price)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Text("원")
                    .padding(.leading, -5)
            }
        }
        .padding(.bottom, 10)
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(price: .constant(""))
    }
}
