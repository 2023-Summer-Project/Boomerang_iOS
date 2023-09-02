//
//  SearchView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @State private var search: String = ""
    @Binding var selectedItem: Int
    @Binding var showExistingMessageDetail: Bool
    @Binding var selectedProduct: Product?
    
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                TextField("검색어를 입력하세요", text: $search)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    self.search = ""
                    self.endTextEditing()
                }, label: {
                    Image(systemName: "x.circle.fill")
                        .padding([.trailing], 10)
                        .foregroundColor(.gray)
                })
            }
            
            ProductListView(selectedItem: $selectedItem, showExistingMessageDetail: $showExistingMessageDetail, selectedProduct: $selectedProduct, products: productViewModel.filteredProducts)
                .environmentObject(authentication)
                .environmentObject(productViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(userInfoViewModel)
                .environmentObject(transactionViewModel)
                .onChange(of: search, perform: {
                    productViewModel.searchProducts($0)
                })
        }
        .padding()
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedItem: .constant(2), showExistingMessageDetail: .constant(false), selectedProduct: .constant(nil))
            .environmentObject(Authentication())
            .environmentObject(ProductViewModel())
            .environmentObject(UserInfoViewModel())
            .environmentObject(ChatViewModel())
            .environmentObject(TransactionViewModel())
    }
}
