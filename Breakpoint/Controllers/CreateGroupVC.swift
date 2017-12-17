//
//  CreateGroupVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 16.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleTxtField: InsetTextField!
    @IBOutlet weak var descriptionTxtField: InsetTextField!
    @IBOutlet weak var emailSearchTxtField: InsetTextField!
    @IBOutlet weak var groupMembersLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    // Variables
    var emailArray = [String]()
    var selectedUsers = [String]()
    
    // Constants
    var placeholderForGroupMembersLbl = "Add users to your group"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTxtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if titleTxtField.text == "" || descriptionTxtField.text == "" {
            return
        }
        DataService.instance.getIDs(forUsernames: selectedUsers) { (uids) in
            var userIds = uids
            userIds.append((Auth.auth().currentUser?.uid)!)
            
            let title = self.titleTxtField.text!
            let description = self.descriptionTxtField.text!
        
            DataService.instance.createGroup(withTitle: title, andDescription: description, forUserIds: userIds, completion: { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint("Could not create a group")
                }
            })
            
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        if emailSearchTxtField.text == "" {
            emailArray.removeAll()
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTxtField.text!, completion: { (emailArray) in
                self.emailArray = emailArray
                self.tableView.reloadData()
            })
        }
        
    }
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: USER_CELL, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        let email = emailArray[indexPath.row]
        cell.configureCell(email: email, isSelected: selectedUsers.contains(email))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {
            return
        }
        let username = cell.usernameLbl.text!
        if !selectedUsers.contains(username) {
            selectedUsers.append(username)
        } else {
            let index = selectedUsers.index(of: username)
            selectedUsers.remove(at: index!)
        }
        
        groupMembersLbl.text = selectedUsers.count > 0 ? selectedUsers.joined(separator: ", ") : placeholderForGroupMembersLbl
        doneBtn.isHidden = (selectedUsers.count == 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
}


