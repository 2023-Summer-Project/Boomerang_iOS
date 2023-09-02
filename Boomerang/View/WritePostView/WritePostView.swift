//
//  WritePostView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/21.
//

import SwiftUI
import CoreLocation

struct WritePostView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authentifation: Authentication
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @State private var title: String = ""
    @State private var price: String = ""
    @State private var content: String = ""
    @State private var productName: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showPhotoAlert: Bool = false
    @State private var showTitleAlert: Bool = false
    @State private var showProductNameAlert: Bool = false
    @State private var showPriceAlert: Bool = false
    @State private var showLocationAlert: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var showLocationView: Bool = false
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @Binding var showWritePost: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                SelectImageView(selectedImages: $selectedImages)
                    .alert(isPresented: $showPhotoAlert, content: {
                        Alert(title: Text("사진을 입력해 주세요."))
                    })
                
                InfoView()
                    .padding(.bottom, 10)
                
                TitleView(title: $title)
                    .alert(isPresented: $showTitleAlert, content: {
                        Alert(title: Text("제목을 입력해 주세요."))
                    })
                
                ProductNameView(productName: $productName)
                    .alert(isPresented: $showProductNameAlert, content: {
                        Alert(title: Text("물건 이름을 입력해 주세요."))
                    })
                
                PriceView(price: $price)
                    .alert(isPresented: $showPriceAlert, content: {
                        Alert(title: Text("가격을 입력해 주세요."))
                    })
                
                ContentView(content: $content)
                
                SelectAvailableTimeView(startTime: $startTime, endTime: $endTime)

                SelectLocationButton(showLocationView: $showLocationView)
                    .alert(isPresented: $showLocationAlert, content: {
                        Alert(title: Text("거래 장소를 선택해 주세요."))
                    })
            }
            .padding()
        }
        .navigationTitle("새로운 게시물 작성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showWritePost = false
                }, label: { Text("취소") })
            }
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    if selectedImages.isEmpty {
                        showPhotoAlert = true
                    } else if title.isEmpty {
                        showTitleAlert = true
                    } else if productName.isEmpty {
                        showProductNameAlert = true
                    } else if price.isEmpty {
                        showPriceAlert = true
                    } else if selectedCoordinate.latitude == 0 && selectedCoordinate.longitude == 0 {
                        showLocationAlert = true
                    } else {
                        productViewModel.uploadProduct(images: selectedImages, POST_CONTENT: content, POST_TITLE: title, PRICE: Int(price)!, OWNER_ID: authentifation.currentUser!.uid, PRODUCT_NAME: productName, AVAILABLE_TIME: [startTime, endTime], location: selectedCoordinate, OWNER_NAME: userInfoViewModel.userInfo?.userName ?? "", PROFILE_IMAGE: userInfoViewModel.userInfo?.userProfileImage ?? "")
                        showWritePost = false
                    }
                }, label: { Text("등록") })
            })
        }
        .fullScreenCover(isPresented: $showLocationView, content: {
            NavigationStack {
                ZStack {
                    MapView(selectedCoordinate: $selectedCoordinate)
                        .edgesIgnoringSafeArea(.bottom)
                        .navigationTitle("위치 추가")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    showLocationView = false
                                    selectedCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                }, label: {
                                    Text("취소")
                                })
                            }
                        }
                    
                    Image("MapMaker")
                        .resizable()
                        .frame(width: 117 / 3, height: 170 / 3)
                        .offset(y: -30)
                    
                    VStack {
                        Spacer()
                        Button(action: {
                            showLocationView = false
                        }, label: {
                            HStack {
                                Text("거래 장소로 선택하기")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(.indigo)
                            .cornerRadius(10)
                        })
                        .padding()
                    }
                }
            }
        })
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

struct WritePostView_Previews: PreviewProvider {
    static var previews: some View {
        WritePostView(showWritePost: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(ProductViewModel())
            .environmentObject(UserInfoViewModel())
    }
}
