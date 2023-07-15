//
//  MainView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI

struct MainView: View {
    @State var showSettingView: Bool = false
    @Binding var showMainView: Bool
    
    var body: some View {
        List {
            Text("row1")
            Text("row2")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSettingView = true
                }) {
                    Image(systemName: "gearshape.fill")
                }
                .navigationDestination(isPresented: $showSettingView, destination: {
                    SettingView(showSettingView: $showSettingView, showMainView: $showMainView)
                })
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMainView: .constant(true))
    }
}
