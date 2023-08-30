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
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert: Bool = false
    @State private var showNewMessageDetail: Bool = false
    @State private var showSelectDateView: Bool = false
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
                    OwnerInfoView(product)
                    
                    Divider()
                }
                .padding(6)
                
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
                    .foregroundColor(.gray)
                    .padding(.bottom)
                    
                    Text(product.POST_CONTENT)
                        .font(.system(size: 16))
                        .padding(.bottom)
                }
                
                GroupBox(content: {
                    HStack {
                        Text("\(Int(product.PRICE))")
                            .foregroundColor(.accentColor)
                            .padding(.leading, -5)
                        
                        Text("원")
                            .padding(.leading, -5)
                    }
                }, label: {
                    Text("대여비")
                        .bold()
                        .font(.system(size: 18))
                })
                .padding(.bottom)
                
                Text("거래 희망 시간")
                    .font(.system(size: 18))
                    .bold()
                
                HStack {
                    Text(product.AVAILABLE_TIME[0])
                        .foregroundColor(.indigo)
                        .bold()
                    Text("부터")
                        .padding(.leading, -5)
                    Text(product.AVAILABLE_TIME[1])
                        .foregroundColor(.indigo)
                        .bold()
                    Text("까지")
                        .padding(.leading, -5)
                }
                .padding(.bottom)
                
                HStack {
                    Text("거래 희망 장소")
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer()
                    
                    Text(product.LOCATION)
                }
                
                TransactionLocationMapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: product.LATITUDE, longitude: product.LONGITUDE), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)), places: [Place(location: CLLocationCoordinate2D(latitude: product.LATITUDE, longitude: product.LONGITUDE))])
                    .frame(width: UIScreen.main.bounds.size.width / 1.1, height: UIScreen.main.bounds.size.width)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing])
            .alert("경고", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    productViewModel.deleteProduct(target: product)
                    
                    productViewModel.getProduct()
                    
                    dismiss()
                }
            } message: {
                Text("해당 게시물을 삭제할까요?")
                    .font(.title)
            }
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
                    
                    Button(action: {
                        showSelectDateView = true
                    }, label: {
                        Text("요청하기")
                            .font(.title2)
                            .padding(.all, 7)
                            .background(.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        selectedProduct = product
                        
                        if chatViewModel.isExist(product.id) {
                            showExistingMessageDetail = true
                            selectedItem = 3
                        } else {
                            showNewMessageDetail = true
                        }
                    }, label: {
                        Text("채팅하기")
                            .font(.title2)
                            .padding(.all, 7)
                            .background(.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                }
            }
        }
        .navigationDestination(isPresented: $showNewMessageDetail, destination: {
            MessageDetailView(messagesViewModel: MessagesViewModel(for: nil), selectedProduct: $selectedProduct, messageTitle: product.PRODUCT_NAME)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
        })
        .alert(isPresented: $transactionViewModel.showTransactionAlert) {
            switch transactionViewModel.result {
            case .success:
                Alert(title: Text("알림"), message: Text("거래가 성공적으로 요청 되었습니다."), dismissButton: .default(Text("확인")))
            case .fail:
                Alert(title: Text("알림"), message: Text("거래 요청에 실패 하였습니다."), dismissButton: .default(Text("확인")))
            }
        }
        .sheet(isPresented: $showSelectDateView) {
            SelectDateView(showSelectDateView: $showSelectDateView, price: product.PRICE, product: product)
                .environmentObject(transactionViewModel)
                .presentationDetents([.fraction(0.30)])
//            MultiDateSelectView()
//                .presentationDetents([.medium, .large])
        }
        .ignoresSafeArea(edges: .top)    //위쪽으로 SafeArea 삭제
        .background(Color("background"))
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(showExistingMessageDetail: .constant(false), selectedItem: .constant(1), selectedProduct: .constant(nil), product: Product(id: "", IMAGES_MAP: ["macbook_pro.jpeg": "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/macbook_pro.jpeg?alt=media&token=f3ff574a-b67f-4f5f-9d3c-885444e7b4e1"], IMAGE_MAP_KEYS: ["macbook_pro.jpeg"], AVAILABILITY: true, LOCATION: "동백동", OWNER_ID: "FPREAFuqthsevfqR3tJw", POST_CONTENT: "2022년형 맥북 프로 M2 대여해 드립니다.\n새롭게 선보이는 M2 칩의 힘으로 MacBook Pro 13의 성능이 다시 한번 도약합니다. 여전히 콤팩트한 디자인은 유지한 채 최대 20시간의 배터리 사용 시간을 제공하고,1 액티브 쿨링 시스템이 향상된 성능을 지속적으로 발휘할 수 있게 해주죠. 여기에 선명한 Retina 디스플레이, FaceTime HD 카메라, 스튜디오급 마이크까지. 그야말로 Apple 최고의 휴대성을 자랑하는 프로용 노트북입니다.", POST_TITLE: "맥북 빌려드립니다.", PRICE: 50000.0, PRODUCT_NAME: "맥북", TIMESTAMP: Timestamp(date: Date()), OWNER_NAME: "test name", PROFILE_IMAGE: "https://firebasestorage.googleapis.com/v0/b/ios-demo-ae41b.appspot.com/o/2023_summer_project.png?alt=media&token=692ddad2-7b3f-4b5d-b5aa-507a9d994d97", LONGITUDE: 127.15110757397726, LATITUDE: 37.283673549013166, AVAILABLE_TIME: ["오후 5시 00분", "오후 10시 00분"]))
            .environmentObject(Authentication())
            .environmentObject(ProductViewModel())
            .environmentObject(ChatViewModel())
            .environmentObject(UserInfoViewModel())
            .environmentObject(TransactionViewModel())
    }
}
