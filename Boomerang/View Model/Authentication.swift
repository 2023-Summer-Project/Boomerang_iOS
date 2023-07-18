//
//  Authentication.swift
//  Boomerang
//
//  Created by 이정훈 on 2023/07/15.
//

import Foundation
import FirebaseAuth

enum EmailInputState {
    case empty, unformed, existed, enabled
}

final class Authentication: ObservableObject {
    //    @Published var isSignIn: Bool = false
    @Published var emailInputState: EmailInputState = .empty
    @Published var isVerifiedEmail: Bool = false
    @Published var timeLeft: Int = 180
    @Published var isSignUpProcess: Bool = false
    
    private var timerList: [Timer] = []
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    //MARK: - Sign In Method
//    func signIn(userEmail: String, userPw: String, completion: @escaping (Bool) -> Void) {
//        //로그인 시도
//        Auth.auth().signIn(withEmail: userEmail, password: userPw) { (user, error) in
//            if user != nil {
//                //self.isSignIn = true
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//    }
    
    //MARK: - Sign In Method with async await
    func signIn(userEmail: String, userPw: String) async -> Bool {
        do {
            try await Auth.auth().signIn(withEmail: userEmail, password: userPw)
        } catch {
            return false
        }
        
        return true
    }
    
    //MARK: - Sign Out method
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - check Email Verification method
    func validateEmail(email: String) {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: email)
        
        if isValid {
            Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethod, error) in
                self.emailInputState = signInMethod != nil ? .existed : .enabled
            }
        } else {
            emailInputState = email.isEmpty ? .empty : .unformed
        }
    }
    
    //MARK: - Sign Up method
    func signUp(email: String) {
        //화면 변경 안되게 flag 변수 update
        isSignUpProcess.toggle()
        
        //인증 메일 재전송시 기존 계정 삭제
        if let user = currentUser {
            removeUser(user: user)
        }
        
        Auth.auth().createUser(withEmail: email, password: "3kv8tT") { (authResult, error) in
            self.currentUser!.sendEmailVerification()    //인증 이메일 전송
            
            //실행 중인 타이머가 있다면 종료
            if self.timerList.count > 0 {
                self.timerList.forEach {
                    $0.invalidate()
                }
            }
            
            //타이머 시작
            self.startTimer()
            
            //이메일 확인
            DispatchQueue.global().async {
                while self.timeLeft > 0 {
                    Thread.sleep(forTimeInterval: 1)    //1초 동안 thread 대기
                    
                    if let user = self.currentUser {
                        user.reload()    //유저 정보 reload
                    }
                    
                    if self.currentUser!.isEmailVerified == true {
                        //UI update는 main thread에서 수행
                        DispatchQueue.main.async {
                            self.isVerifiedEmail = true
                        }
                        
                        self.timerList[0].invalidate()    //타이머 중지
                        break
                    }
                }
            }
        }
    }
    
    //MARK: - remove User Method
    func removeUser(user: User?) {
        user?.delete { error in
            if let error = error {
                print("removeUser(user:): - ", error)
            } else {
                print("removeUser(user:): - Account deleted")
            }
        }
    }
    
    //MARK: - User Password update Method
    func updatePw(email: String, password: String) {
        currentUser?.updatePassword(to: password) { _ in
            //회원가입 종료
            self.emailInputState = .empty
            self.isVerifiedEmail.toggle()
            self.timeLeft = 180
            self.isSignUpProcess.toggle()
        }
    }
    
    //MARK: - 타이머가 매초 수행할 로직
    func updateTimer(timer: Timer) {
        timeLeft -= 1
        
        if timeLeft < 1 {
            timer.invalidate()    //타이머 종료
            
            //만약 시간 내에 인증이 되지 않으면 계정 삭제
            if !isVerifiedEmail {
                removeUser(user: currentUser)
            }
        }
    }
    
    //MARK: - start Timer
    func startTimer() {
        //1초 마다 수행하는 타이머
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.updateTimer(timer: timer)
        })
        
        timerList.append(timer)
    }
    
    //MARK: - resend Email
    func resendEmail(email: String) {
        timeLeft = 180
        signUp(email: email)
    }
}
