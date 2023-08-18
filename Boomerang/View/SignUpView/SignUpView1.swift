//
//  SignUpView1.swift
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
    @Binding var showMainView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "1.circle")
                Text("이메일 인증")
            }
            .font(.title)
            .fontWeight(.medium)
            .padding(.bottom)
            
            Text("안전한 이용을 위해 이메일 인증을 시도합니다.")
                .font(.title3)
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
            
            EmailStateView(emailInputState: $authentication.emailInputState)
            
            if isButtonClicked {
                if authentication.isVerifiedEmail {
                    Button(action: {
                        showSignUpView2 = true
                    }, label: {
                        HStack {
                            Text("다음")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.indigo)
                        .cornerRadius(10)
                    })
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
                }, label: {
                    HStack {
                        Text("인증 메일 전송")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.indigo)
                    .cornerRadius(10)
                    
                })
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("이메일을 확인 해주세요."))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("취소")
            }
        }
        .navigationDestination(isPresented: $showSignUpView2, destination: {
            SignUpView2(userEmail: inputEmail, showMainView: $showMainView)
                .environmentObject(authentication)
        })
    }
}

struct EmailVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView1(showMainView: .constant(false))
            .environmentObject(Authentication())
            .environmentObject(UserInfoViewModel())
    }
}
