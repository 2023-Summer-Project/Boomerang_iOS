//
//  WebView.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/08/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var progress: Double
    
    let webView = WKWebView()
    let urlString: String
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: urlString) else {
            return WKWebView()
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject {
        private var parent: WebView
        private var observer: NSKeyValueObservation?
        
        init(_ parent: WebView) {
            self.parent = parent
            super.init()
            
            observer = parent.webView.observe(\.estimatedProgress) { [weak self] (webView, _) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.parent.progress = webView.estimatedProgress
                }
            }
        }
        
        deinit {
            observer = nil
        }
    }
}

struct WebView_preview: PreviewProvider {
    static var previews: some View {
        WebView(progress: .constant(0.0), urlString: "https://2023-summer-project.github.io/Boomerang-OSS-Notice/OSSNotice_iOS.html")
    }
}
