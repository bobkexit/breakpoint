//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController, GIDSignInUIDelegate{
    
    // Outlets
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var fbSignInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dismissIfNeeded()
    }
    
    @IBAction func signInWithEmailPressed(_ sender: Any) {        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: SB_LoginVC) else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func signInWithFacebook(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                self.displayErrorAlert(title: "Failed sign in with facebook", error: error)
                return
            } else {
                if (result?.isCancelled)! {
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        self.displayErrorAlert(title: "Failed sign in with facebook", error: error)
                    } else {
                        let user = user!
                        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
                            if !snapshot.hasChild(user.uid) {
                                let userData: [String: Any] = ["provider": user.providerID,
                                                               "email": user.email!]
                                DataService.instance.createDBUser(uid: user.uid, userData: userData)
                            }
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        //dismissIfNeeded()
    }
    
    func dismissIfNeeded() {
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    func displayErrorAlert(title: String, error: Error) {
        let alertVC = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        present(alertVC, animated: true, completion: nil)
    }
}
