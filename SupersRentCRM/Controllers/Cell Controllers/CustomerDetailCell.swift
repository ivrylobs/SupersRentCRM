//
//  CustomerDetailCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 11/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerDetailCell: UITableViewCell {
	
	var customerData: JSON?
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var identityLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
