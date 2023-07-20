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
    @StateObject var authentication: Authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // 로그인이 되어 있는 경우
                if authentication.currentUser != nil && authentication.isSignUpProcess == false {
                    SignInView(showMainView: true)
                        .environmentObject(authentication)
                }
                //로그인이 안되어 있는 경우
                else {
                    SignInView(showMainView: false)
                        .environmentObject(authentication)
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
