//
//  SignInView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authentication: Authentication
    @Environment(\.colorScheme) var colorScheme
    @State private var inputEmail: String = ""
    @State private var inputPw: String = ""
    @State private var showAlert: Bool = false
    @State private var showSignUpView: Bool = false
    @State private var isLoading: Bool = false
    @State var showMainView: Bool
    
    var body: some View {
        ZStack {
            Text("반갑습니다!")
                .bold()
                .foregroundColor(.white)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                .background(Color.indigo)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 50,
                        bottomTrailingRadius: 50,
                        topTrailingRadius: 0
                    )
                )
                .offset(y: -(UIScreen.main.bounds.height / 2.8))
                .shadow(color: .gray, radius: 10, x: 0, y: 7)
            
            
            VStack {
                TextField("이메일", text: $inputEmail)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
                
                SecureField("비밀번호", text: $inputPw)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)
                
                Button(action: {
                    Task {
                        if await authentication.signIn(userEmail: inputEmail, userPw: inputPw) {
                            showMainView.toggle()
                        } else {
                            showAlert.toggle()
                        }
                    }
                }, label: {
                    HStack {
                        Text("로그인")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo)
                    .cornerRadius(10)
                })
                .padding(.bottom, 10)
                .alert("이메일이 존재하지 않거나 비밀번호가 일치하지 않습니다.", isPresented: $showAlert) {
                    Button("확인", role: .cancel) {}
                }
                
                Divider()
                
                NavigationLink(destination: {
                    SignUpView1(showMainView: $showMainView)
                        .environmentObject(authentication)
                }, label: {
                    Text("회원가입")
                        .font(.headline)
                        .padding(.top, 10)
                })
            }
            .padding()
        }
        .navigationDestination(isPresented: $showMainView, destination: {
            MainView(showMainView: $showMainView)
                .environmentObject(authentication)
        })
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showMainView: false)
            .environmentObject(Authentication())
    }
}
