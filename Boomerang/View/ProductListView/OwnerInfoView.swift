//
//  OwnerInfoView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/15.
//

import SwiftUI

struct OwnerInfoView: View {
    var location: String
    var ownerId: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text(location)
                    .font(.system(size: 16))
                
                Text("작성자 ID: \(ownerId)")
                    .font(.system(size: 13))
            }
        }
    }
}

struct OwnerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerInfoView(location: "동백동", ownerId: "ownerId")
    }
}
