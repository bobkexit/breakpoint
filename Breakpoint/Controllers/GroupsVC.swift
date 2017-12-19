//
//  SecondViewController.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            DataService.instance.getGroups(forUserId: (Auth.auth().currentUser?.uid)!) { (groups) in
                self.groups = groups
                self.tableView.reloadData()
            }
        }
    }
}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GROUP_CELL, for: indexPath) as? GroupCell else {
            return UITableViewCell()
        }
        let group = groups[indexPath.row]
        cell.configureCell(group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: SB_GroupFeedVC) as? GroupFeedVC else {
            return
        }
        let group = groups[indexPath.row]
        groupFeedVC.initData(group: group)
        present(groupFeedVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
}

