//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    @EnvironmentObject var authentication: Authentication
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showMainView: Bool
    
    var body: some View {
        List {
            UserInfoView(userInfo: $userInfoViewModel.userInfo)
                .listRowSeparator(.hidden)
            
            Section(header: Text("내 거래"), content: {
                NavigationLink(destination: {
                    TransectionListView()
                }, label: {
                    Text("진행 중인 거래")
                        .padding([.top, .bottom], 10)
                })
                
                NavigationLink(destination: {
                    EndedTransectionListView()
                }, label: {
                    Text("완료한 거래")
                        .padding([.top, .bottom], 10)
                })
            })
            
            Section(header: Text("내 물건"), content: {
                NavigationLink(destination: {
                    MyProductListView()
                }, label: {
                    Text("내가 등록한 물건")
                        .padding([.top, .bottom], 10)
                })
            })
            
            Section(header: Text("로그인 관리"), content: {
                Button(action: {
                    authentication.signOut()
                    showMainView = false
                }, label: {
                    Text("로그아웃")
                        .foregroundColor(.red)
                        .padding([.top, .bottom], 10)
                })
            })
        }
        .listStyle(.plain)
        .safeAreaInset(edge: .top) {
            HStack {
                Text("내 정보")
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: {
                    SettingView()
                }, label: {
                    Image(systemName: "gearshape.fill")
                })
            }
            .padding()
            .font(.title2)
            .background(colorScheme == .light ? .white : .black)
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showMainView: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(UserInfoViewModel())
    }
}
