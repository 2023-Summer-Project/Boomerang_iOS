//
//  SignUpView2.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/17.
//

import SwiftUI

struct SignUpView2: View {
    @EnvironmentObject var authentication: Authentication
    @State var userEmail: String
    @State private var userName: String = ""
    @State private var inputPw1: String = ""
    @State private var inputPw2: String = ""
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Image(systemName: "2.circle")
                    Text("- 정보 입력")
                }
                .font(.title2)
                .padding(.bottom)
                
                HStack {
                    Text("이메일")
                    Spacer()
                }
                
                TextField(userEmail, text: $userEmail)
                    .disabled(true)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
        
        Group {
            VStack {
                HStack {
                    Text("닉네임")
                    Spacer()
                }
                
                TextField("", text: $userName)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text("비밀번호")
                    Spacer()
                }
                
                SecureField("", text: $inputPw1)
                    .textFieldStyle(.roundedBorder)
                
                if inputPw1.count < 6 {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("비밀번호는 6자리 이상이어야 합니다.")
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                } else {
                    Text("")
                        .padding(.top, 5)
                        .padding(.bottom, 6.7)
                }
                
                HStack {
                    Text("비밀번호 확인")
                    Spacer()
                }
                
                SecureField("", text: $inputPw2)
                    .textFieldStyle(.roundedBorder)
                
                if inputPw1 != inputPw2 {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("비밀번호가 일치하지 않습니다.")
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                } else {
                    Text("")
                        .padding(.top, 5)
                        .padding(.bottom, 6.7)
                }
            }
            .padding()
        }
        
        Group {
            Button(action: {
                if inputPw1.count >= 6 && inputPw1 == inputPw2 {
                    authentication.updatePw(email: userEmail, password: inputPw1)
                } else {
                    //비밀번호가 일치하지 않거나 비밀번호가 6자리 미만일때
                }
            }, label: { Text("다음") })
            .buttonStyle(.bordered)
        }
    }
}

struct SignUpView2_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView2(userEmail: "admin@boomerang.com")
    }
}
