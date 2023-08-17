//
//  SettingView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI

struct SettingView: View {
    @StateObject var userViewModel: UserInfoViewModel = UserInfoViewModel()
    @EnvironmentObject var authentication: Authentication
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showMainView: Bool
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea(.all)
            
            List {
                UserInfoView(userInfo: $userViewModel.userInfo)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("background"))
                    .listRowInsets(EdgeInsets())
                
                Section(header: Text("내 거래"), content: {
                    NavigationLink(destination: {
                        TransectionListView()
                    }, label: {
                        Text("진행 중인 거래")
                            .font(.title3)
                            .padding([.top, .bottom], 10)
                    })
                    
                    NavigationLink(destination: {
                        EndedTransectionListView()
                    }, label: {
                        Text("완료한 거래")
                            .font(.title3)
                            .padding([.top, .bottom], 10)
                    })
                })
                .listRowBackground(Color("background"))
                
                Section(header: Text("내 물건"), content: {
                    NavigationLink(destination: {
                        MyProductListView()
                    }, label: {
                        Text("내가 등록한 물건")
                            .font(.title3)
                            .padding([.top, .bottom], 10)
                    })
                })
                .listRowBackground(Color("background"))
                
                Section(header: Text("로그인 관리"), content: {
                    Button(action: {
                        authentication.signOut()
                        showMainView = false
                    }, label: {
                        Text("로그아웃")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding([.top, .bottom], 10)
                    })
                })
                .listRowBackground(Color("background"))
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .top) {
                HStack {
                    Text("내 정보")
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "gearshape.fill")
                    })
                }
                .padding()
                .font(.title2)
                .background(colorScheme == .light ? .white : Color("background"))
            }
        }
        .onAppear {
            userViewModel.getUserInfo()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showMainView: .constant(true))
            .environmentObject(Authentication())
            .environmentObject(UserInfoViewModel())
    }
}
