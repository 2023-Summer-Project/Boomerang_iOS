//
//  BoomerangApp.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/14.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct BoomerangApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let user = Auth.auth().currentUser {
                    SignInView(showMainView: true)
                } else {
                    SignInView(showMainView: false)
                }
            }
        }
    }
}
