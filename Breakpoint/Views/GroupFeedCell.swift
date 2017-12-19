//
//  GroupFeedCell.swift
//  Breakpoint
//
//  Created by Николай Маторин on 18.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    func configureCell(message: Message) {
        profileImg.image = #imageLiteral(resourceName: "defaultProfileImage")
        messageLbl.text = message.content
        DataService.instance.getUserName(forUID: message.senderId) { (username) in
            self.usernameLbl.text = username
        }
    }
    
}
