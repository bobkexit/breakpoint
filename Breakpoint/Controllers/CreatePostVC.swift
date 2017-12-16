//
//  CreatePostVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 16.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var postTxtView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.bindToKeyboard()
        postTxtView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userEmailLbl.text = Auth.auth().currentUser?.email
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if postTxtView.text == nil || postTxtView.text == PLACEHOLDER_FOR_TEXTVIEW {
            return
        }
        DataService.instance.uploadPost(withMessage: postTxtView.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                debugPrint("An error occurs")
            }
        }
    }
    
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
