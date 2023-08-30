//
//  MainRowView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import SwiftUI
import FirebaseFirestore

struct ProductListRowView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.IMAGES_MAP[product.IMAGE_MAP_KEYS[0]]!)) { image in
                image
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    .cornerRadius(15)
            } placeholder: {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 209 / 255, green: 209 / 255, blue: 209 / 255))
                    ProgressView()
                }
                .frame(width: 100.0, height: 100.0)
                .cornerRadius(15)
            }
            
            
            VStack(alignment: .leading) {
                Text(product.POST_TITLE)
                    .font(.system(size: 20, weight: .medium))
                
                HStack {
                    Text(product.LOCATION)
                    
                    Text("•")
                        .padding([.leading, .trailing], -5)
                    
                    TimestampView(product)
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                
                HStack {
                    Text("\(Int(product.PRICE))")
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
        ProductListRowView(product: Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "맥북", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", TIMESTAMP: Timestamp(), OWNER_NAME: "user name", PROFILE_IMAGE: "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/2023_summer_project.png?alt=media&token=692ddad2-7b3f-4b5d-b5aa-507a9d994d97", LONGITUDE: 127.15110757397726, LATITUDE: 37.283673549013166, AVAILABLE_TIME: ["오후 5시 00분", "오후 10시 00분"]))
            .environmentObject(ProductViewModel())
    }
}
