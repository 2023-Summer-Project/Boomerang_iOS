//
//  SelectLocationButton.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/24.
//

import SwiftUI

struct SelectLocationButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showLocationView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("거래 장소 추가")
                .bold()
                
            Button(action: {
                showLocationView = true
            }, label: {
                Text("위치 추가")
                    .font(.headline)
                    .foregroundColor(colorScheme == .light ? .gray : .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .light ? .gray : .white, lineWidth: 2))
            })
        }
        .padding(.bottom, 10)
    }
}

struct SelectLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectLocationButton(showLocationView: .constant(false))
    }
}
