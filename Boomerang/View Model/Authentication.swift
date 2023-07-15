//
//  Authentication.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import FirebaseAuth

final class Authentication: ObservableObject {
    @Published var showMainView: Bool = false
    @Published var showAlert: Bool = false
    
    func signIn(userEmail: String, userPw: String) {
        Auth.auth().signIn(withEmail: userEmail, password: userPw) { (user, error) in
            if user != nil {
                self.showMainView = true
            } else {
                self.showAlert = true
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
