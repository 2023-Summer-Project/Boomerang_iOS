//
//  SignInView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct SignInView: View {  
    @EnvironmentObject var authentication: Authentication
    @State private var inputEmail: String = ""
    @State private var inputPw: String = ""
    @State private var showAlert: Bool = false
    @State private var showSignUpView: Bool = false
    @State private var isLoading: Bool = false
    @State var showMainView: Bool
    
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
            
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
                Text("로그인")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 158)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            })
            .padding(.bottom, 10)
            .alert("이메일이 존재하지 않거나 비밀번호가 일치하지 않습니다.", isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            }
//            .alert(isPresented: $isLoading) {
//                Alert(title: Text("로그인 중입니다."), dismissButton: nil)
//            }
            
            Divider()
            
            Button(action: { showSignUpView = true }) {
                Text("회원가입")
                    .font(.headline)
            }
            .padding(.top, 10)
            
            NavigationLink(isActive: $showMainView, destination: {
                MainView(showMainView: $showMainView)
                    .environmentObject(authentication)
            }, label: {})
            
            NavigationLink(isActive: $showSignUpView, destination: {
                SignUpView1()
                    .environmentObject(authentication)
            }, label: {})
        }
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showMainView: false)
            .environmentObject(Authentication())
    }
}
