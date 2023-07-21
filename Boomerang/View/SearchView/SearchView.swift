//
//  SearchView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/20.
//

import SwiftUI

struct SearchView: View {
    @State var search: String = ""
    
    var body: some View {
        NavigationView {
            List {
                
            }
        }
        .searchable(text: $search)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
