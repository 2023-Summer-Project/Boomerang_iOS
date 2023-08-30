//
//  OwnerInfoView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/15.
//

import SwiftUI
import FirebaseFirestore

struct OwnerInfoView: View {
    var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: product.PROFILE_IMAGE)) { image in
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            
            Text(product.OWNER_NAME)
                .font(.system(size: 20))
                .bold()
        }
    }
}

struct OwnerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerInfoView(Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", TIMESTAMP: Timestamp(date: Date()), OWNER_NAME: "test name", PROFILE_IMAGE: "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/2023_summer_project.png?alt=media&token=692ddad2-7b3f-4b5d-b5aa-507a9d994d97", LONGITUDE: 127.15110757397726, LATITUDE: 37.283673549013166, AVAILABLE_TIME: ["오후 5시 00분", "오후 10시 00분"]))
    }
}
