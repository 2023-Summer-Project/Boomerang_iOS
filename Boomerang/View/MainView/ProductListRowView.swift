//
//  MainRowView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import SwiftUI
import FirebaseStorage

struct ProductListRowView: View {
    @EnvironmentObject var fireStore: FireStore
    
    var product: ProductInfo
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: product.2 ?? UIImage(systemName: "info.circle")!)
                .resizable()
                .frame(width: 100.0, height: 100.0)
                .cornerRadius(15)
            
            
            VStack(alignment: .leading) {
                Text(product.1.POST_TITLE)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.bottom, 1.5)
                
                HStack {
                    Text("\(Int(product.1.PRICE))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.accentColor)
                    Text("원")
                        .padding(.leading, -5)
                }
            }
            .padding(.leading, 3)
            
            Spacer()
        }
    }
}

struct ProductListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListRowView(product: ("TvxG3typJb5LyzYXdPDL" , Product(IMAGES: ["2023_summer_project.png"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "맥북", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북"), UIImage(contentsOfFile: "2023_summer_project")))
            .environmentObject(FireStore())
    }
}
