//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Николай Маторин on 16.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var countMembersLbl: UILabel!
    
    func configureCell(group: Group) {
        titleLbl.text = group.title
        descriptionLbl.text = group.description
        countMembersLbl.text = "\(group.members.count)"
    }
}
