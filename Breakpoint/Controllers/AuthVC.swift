//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {
    
    // Outlets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInWithEmailPressed(_ sender: Any) {        
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: SB_LoginVC) else { return }
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func signInWithFacebook(_ sender: Any) {
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
    }
}
