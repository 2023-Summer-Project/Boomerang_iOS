//
//  AppLicenseView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/21.
//

import SwiftUI

struct AppLicenseView: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack {
            if progress < 1 {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .indigo))
            }
            
            WebView(progress: $progress, urlString: "https://2023-summer-project.github.io/Boomerang-OSS-Notice/OSSNotice_iOS.html")
        }
        .navigationTitle("오픈소스 라이선스")
    }
}

struct AppLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        AppLicenseView()
    }
}
