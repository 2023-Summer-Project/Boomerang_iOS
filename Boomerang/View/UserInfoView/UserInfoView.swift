//
//  UserInfoView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import SwiftUI
import FirebaseAuth

struct UserInfoView: View {
    @Binding var userInfo: UserInfo?
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: userInfo?.userProfileImage ?? ""), content: { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 6)
                }, placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 10)
                })
                
                VStack(alignment: .leading) {
                    Text(userInfo?.userName ?? "")
                        .font(.title2)
                        .bold()
                    
                    Text(userInfo?.userEmail ?? "")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding([.leading, .top, .bottom])
            
//            Button(action: {}, label: {
//                Text("회원정보 수정")
//            })
//            .padding([.leading, .bottom, .trailing])
            
        }
        .foregroundColor(.white)
        .background(.indigo)
        .cornerRadius(10)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(userInfo: .constant(UserInfo(userName: "", userEmail: "", userProfileImage: "")))
    }
}
