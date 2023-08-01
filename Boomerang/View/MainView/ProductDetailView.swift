//
//  ProductDetailView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @State private var showDeleteAlert: Bool = false
    
    var product: Product
    
    var body: some View {
        ScrollView {            
            TabView {
                ForEach(product.IMAGE_MAP_KEYS, id:\.self) { key in
                    AsyncImage(url: URL(string: product.IMAGES_MAP[key]!)) { image in
                        image
                            .resizable()
                            .frame(width: 400, height: 400)
                    } placeholder: {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 209 / 255, green: 209 / 255, blue: 209 / 255))
                            ProgressView()
                        }
                    }
                }
            }
            .tabViewStyle(.page)
            .frame(width: 400, height: 400)
            
            VStack(alignment: .leading) {
                Text(product.POST_TITLE)
                    .font(.system(size: 30, weight: .bold))
                
                HStack {
                    Text("대여비: ")
                    Text("\(Int(product.PRICE))")
                        .foregroundColor(.accentColor)
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
        .if(product.OWNER_ID == authentication.currentUser?.uid) { view in
            view.toolbar {
                ToolbarItem {
                    Button(action: {
                        showDeleteAlert = true
                    }, label: { Image(systemName: "trash.fill") })
                }
            }
        }
        .alert("경고", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                fireStoreViewModel.deleteProduct(target: product)
                fireStoreViewModel.fetchProduct()
            }
        } message: {
            Text("해당 게시물을 삭제할까요?")
                .font(.title)
        }
        .ignoresSafeArea(edges: .top)    //위쪽으로 SafeArea 삭제
    }
}

extension View {
    //if modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
           transform(self)
        } else {
            self
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북"))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
    }
}
