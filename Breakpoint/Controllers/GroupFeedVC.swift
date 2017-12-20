//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Николай Маторин on 18.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendMessageStackView: UIStackView!
    
    var refHandle: UInt?
    var group: Group?
    var messages = [Message]()
    
    
    func initData(group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.title
        
        DataService.instance.getEmails(forGroup: group!) { (emails) in
            self.membersLbl.text = emails.joined(separator: ", ")
        }
        
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        
        refHandle = DataService.instance.REF_FEED.observe(.value) { (snapshot) in
            DataService.instance.getFeedMessages(forGroup: self.group!) { (groupMessages) in
                self.messages = groupMessages
                self.tableView.reloadData()
                
                if self.messages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .none, animated: true)
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let refHandle = refHandle {
            DataService.instance.REF_FEED.removeObserver(withHandle: refHandle)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        dismissDetail()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if textField.text == nil || textField.text == "" {
            return
        }
        let message = textField.text!
        let senderId = Auth.auth().currentUser?.uid
        let groupId = group?.id
        
        DataService.instance.uploadPost(withMessage: message, forUID: senderId!, withGroupKey: groupId) { (success) in
            if (success) {
                self.textField.text = ""
                self.view.endEditing(true)
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GROUP_FEED_CELL, for: indexPath) as? GroupFeedCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
