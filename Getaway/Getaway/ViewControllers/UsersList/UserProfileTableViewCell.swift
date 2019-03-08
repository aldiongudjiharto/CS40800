//
//  UserProfileTableViewCell.swift
//  Getaway
//
//  Created by Avinash Singh on 07/03/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var relationLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
