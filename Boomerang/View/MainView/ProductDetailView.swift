//
//  ProductDetailView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("2023_summer_project")
                    .resizable()
                    .frame(width: 400, height: 400)
                
                Text(product.POST_TITLE)
                    .font(.system(size: 30, weight: .bold))
                    
                Text("작성자 ID: \(product.OWNER_ID)")
                
                Text(product.POST_CONTENT)
                    
            }
            .padding()
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "맥북", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북"))
    }
}
