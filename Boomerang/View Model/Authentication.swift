//
//  Authentication.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import FirebaseAuth

enum EmailInputState {
    case empty, unformed, existed, enabled
}

final class Authentication: ObservableObject {
//    @Published var isSignIn: Bool = false
//    @Published var emailInputState: EmailInputState = .empty
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    //MARK: - Sign In Method
    func signIn(userEmail: String, userPw: String, completion: @escaping (Bool) -> Void) {
        //로그인 시도
        Auth.auth().signIn(withEmail: userEmail, password: userPw) { (user, error) in
            if user != nil {
//                self.isSignIn = true
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //MARK: - Sign Out Method
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
//    func checkEmail(email: String) {
//        if email.isEmpty {
//            emailInputState = .empty
//        }
//    }
}
