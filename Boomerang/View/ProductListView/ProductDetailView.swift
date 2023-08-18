//
//  ProductDetailView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/19.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct ProductDetailView: View {
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @State private var showDeleteAlert: Bool = false
    @Binding var showMessageDetail: Bool
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedItem: Int
    @Binding var selectedProduct: Product?
    
    var product: Product
    
    var body: some View {
        ScrollView {            
            TabView {
                ForEach(product.IMAGE_MAP_KEYS, id:\.self) { key in
                    AsyncImage(url: URL(string: product.IMAGES_MAP[key]!)) { image in
                        image
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
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
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            
            VStack(alignment: .leading) {
                Group {
                    OwnerInfoView(location: product.LOCATION, ownerId: product.OWNER_ID)
                    
                    Divider()
                }
                .padding(.top)
                
                Group {
                    Text(product.POST_TITLE)
                        .font(.system(size: 25, weight: .bold))
                    
                    HStack {
                        Text(product.PRODUCT_NAME)
                            .font(.system(size: 16))
                        
                        Text("•")
                        
                        TimestampView(product)
                            .font(.system(size: 16))
                    }
                    .padding(.bottom)
                    
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
                    .font(.system(size: 18))
                    .padding(.bottom)
                    
                    Text(product.POST_CONTENT)
                        .font(.system(size: 16))
                        .padding(.bottom)
                }
            }
            .padding([.leading, .trailing])
            
            VStack {
                HStack {
                    Text("거래 희망 장소")
                        .bold()
                    Spacer()
                }
                
                MapView()
                    .frame(width: UIScreen.main.bounds.size.width - 26, height: UIScreen.main.bounds.size.height / 5)
                    .cornerRadius(10)
            }
            .padding()
        }
        .toolbar {
            if product.OWNER_ID == authentication.currentUser?.uid {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeleteAlert = true
                    }, label: { Image(systemName: "trash.fill") })
                }
            }
        }
        .toolbar {
            if product.OWNER_ID != authentication.currentUser?.uid {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text("거래 요청하기")
                            .padding(.all, 7)
                            .background(.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        selectedProduct = product
                        
                        if chatViewModel.isExist(product.id) {
                            selectedItem = 3
                            showExistingMessageDetail = true
                        } else {
                            showMessageDetail = true
                        }
                    }, label: {
                        Text("채팅하기")
                            .padding(.all, 7)
                            .background(.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                }
            }
        }
        .navigationDestination(isPresented: $showMessageDetail, destination: {
            MessageDetailView(messagesViewModel: MessagesViewModel(for: nil), selectedProduct: $selectedProduct, messageTitle: selectedProduct?.PRODUCT_NAME ?? "")
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
        })
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
        .background(Color("background"))
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(showMessageDetail: .constant(false), showExistingMessageDetail: .constant(false), selectedItem: .constant(1), selectedProduct: .constant(nil), product: Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", PRODUCT_TYPE: "노트북", TIMESTAMP: Timestamp(date: Date())))
            .environmentObject(Authentication())
            .environmentObject(FireStoreViewModel())
            .environmentObject(ChatViewModel())
    }
}
