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
            Image("2023_summer_project")
                .resizable()
                .frame(width: 400, height: 400)
            
            VStack(alignment: .leading) {
                Text(product.POST_TITLE)
                    .font(.system(size: 30, weight: .bold))
                
                HStack {
                    Text("대여비: ")
                    Text("\(Int(product.PRICE))")
                        .foregroundColor(.green)
                        .bold()
                        .padding(.leading, -5)
                    Text("원")
                        .padding(.leading, -5)
                    Spacer()
                }
                .font(.system(size: 20))

                Text("작성자 ID: \(product.OWNER_ID)")
                    .font(.system(size: 13))
                    .padding(.bottom)
                
                
                Text(product.POST_CONTENT)
                    .font(.system(size: 20))
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북"))
    }
}
