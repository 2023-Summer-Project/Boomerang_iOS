//
//  ProductNameView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/14.
//

import SwiftUI

struct ProductNameView: View {
    @Binding var productName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("물건 이름")
                .bold()
            
            TextField("물건의 이름을 작성해 주세요.", text: $productName)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.bottom, 10)
    }
}

struct ProductNameView_Previews: PreviewProvider {
    static var previews: some View {
        ProductNameView(productName: .constant(""))
    }
}
