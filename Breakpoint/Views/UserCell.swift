//
//  UserCell.swift
//  Breakpoint
//
//  Created by Николай Маторин on 16.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(email: String, isSelected: Bool) {
        //profileImg.image = #imageLiteral(resourceName: "defaultProfileImage")
        usernameLbl.text = email
        checkImg.isHidden = !isSelected
    }
}
