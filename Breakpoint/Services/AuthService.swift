//
//  AuthService.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static var instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, completionHandler: @escaping AuthCompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                completionHandler(false, error)
                return
            }
            let userData: [String: Any] = ["provider": user.providerID,
                                           "email": user.email!]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            completionHandler(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, completionHandler: @escaping AuthCompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completionHandler((error == nil), error)
        }
    }
}
