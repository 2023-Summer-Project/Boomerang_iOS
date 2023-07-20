//
//  EmailVerifyView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/16.
//

import SwiftUI

struct SignUpView1: View {
    @EnvironmentObject var authentication: Authentication
    @State private var inputEmail: String = ""
    @State private var isButtonClicked: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSignUpView2: Bool = false
    @State private var showEmailNotVerifiedAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "1.circle")
                Text("- 이메일 인증")
            }
            .font(.title2)
            .padding(.bottom)
            
            Text("안전한 이용을 위해 이메일 인증을 시도합니다.")
                .padding(.bottom)
            
            HStack {
                Text("사용할 이메일")
                Spacer()
            }
            
            TextField(text: $inputEmail, label: {})
                .onChange(of: inputEmail) { _ in
                    authentication.validateEmail(email: inputEmail)
                }
                .textFieldStyle(.roundedBorder)
            
            switch authentication.emailInputState {
            case .empty:
                HStack {
                    Image(systemName: "info.circle")
                    Text("이메일을 입력하세요.")
                    Spacer()
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(.accentColor)
            case .enabled:
                HStack {
                    Image(systemName: "info.circle")
                    Text("사용 가능한 이메일입니다.")
                    Spacer()
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(.black)
            case .existed:
                HStack {
                    Image(systemName: "info.circle")
                    Text("이미 사용 중인 이메일입니다.")
                    Spacer()
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(.red)
            case .unformed:
                HStack {
                    Image(systemName: "info.circle")
                    Text("잘못된 형식입니다.")
                    Spacer()
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(.red)
            }
            
            if isButtonClicked {
                if authentication.isVerifiedEmail {
                    Text("이메일 인증이 완료 되었습니다.")
                } else {
                    HStack {
                        Button(action: {
                            authentication.resendEmail(email: inputEmail)
                        }, label: { Text("재전송") })
                        Text("\(authentication.timeLeft / 60)분 \(authentication.timeLeft % 60)초")
                    }
                }
            } else {
                Button(action: {
                    if authentication.emailInputState == .enabled {
                        authentication.signUp(email: inputEmail)
                        isButtonClicked = true
                    } else {
                        showAlert = true
                    }
                }, label: { Text("인증 메일 전송") })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("이메일을 확인 해주세요."))
                })
            }
            
            Button(action: {
                if authentication.isVerifiedEmail {
                    showSignUpView2 = true
                } else {
                    showEmailNotVerifiedAlert = true
                }
            }, label: { Text("다음") })
            .buttonStyle(.bordered)
            .alert(isPresented: $showEmailNotVerifiedAlert, content: {
                Alert(title: Text("이메일이 인증되지 않았습니다."))
            })
        }
        .navigationDestination(isPresented: $showSignUpView2, destination: {
            SignUpView2(userEmail: inputEmail)
                .environmentObject(authentication)
        })
        .padding()
    }
}

struct EmailVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView1()
            .environmentObject(Authentication())
    }
}
