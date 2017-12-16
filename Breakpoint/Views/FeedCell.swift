//
//  FeedCell.swift
//  Breakpoint
//
//  Created by Николай Маторин on 16.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messageContentLbl: UILabel!
    
    func configureCell(withMessage message: Message) {
        profileImg.image = UIImage(named: "defaultProfileImage")
        DataService.instance.getUserName(forUID: message.senderId) { (userName) in
            self.emailLbl.text = userName
        }
        messageContentLbl.text = message.content
    }

}
