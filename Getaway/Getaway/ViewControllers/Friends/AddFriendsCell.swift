//
//  AddFriendsCell.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/1/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import Foundation
import UIKit

class AddFriendsCell: UITableViewCell {
    var name: String?
    
    @IBOutlet weak var friendUsername: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        accessoryType = selected ? .checkmark : .none
    }
    
}
