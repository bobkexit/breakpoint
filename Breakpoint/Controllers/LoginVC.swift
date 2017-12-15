//
//  LoginVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
//Check lecture 145 10:38
class LoginVC: UIViewController {

    // Outlets
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        if emailField.text == nil || passwordField.text == nil {
            return
        }
        
        AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.passwordField.Toggle()
                debugPrint(error?.localizedDescription as Any)
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
