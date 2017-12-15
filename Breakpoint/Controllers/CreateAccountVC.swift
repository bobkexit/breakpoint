//
//  CreateAccountVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    // Outlets
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if emailField.text == nil || passwordField.text == nil {
            return
        }
        AuthService.instance.registerUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, completionHandler: { (success, error) in
                    if (success) {
                        self.performSegue(withIdentifier: UNWIND, sender: nil)
                    } else {
                         debugPrint(error?.localizedDescription as Any)
                    }
                })
            } else {
                debugPrint(error?.localizedDescription as Any)
            }
        }
    }
    
}
