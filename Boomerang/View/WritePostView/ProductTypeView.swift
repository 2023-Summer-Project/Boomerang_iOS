//
//  ProductTypeView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/14.
//

import SwiftUI

struct ProductTypeView: View {
    @Binding var productType: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("종류")
                .bold()
            TextField("물건의 종류는 무엇인가요?", text: $productType)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct ProductTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ProductTypeView(productType: .constant(""))
    }
}
