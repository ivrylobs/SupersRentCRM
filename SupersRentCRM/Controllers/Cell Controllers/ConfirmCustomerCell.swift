//
//  ConfirmCustomerCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ConfirmCustomerCell: UITableViewCell {
	
	
	@IBOutlet weak var customerName: UILabel!
	@IBOutlet weak var idCard: UILabel!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var customerAddress: UILabel!
	@IBOutlet weak var addressDistrict: UILabel!
	@IBOutlet weak var addressProvince: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
