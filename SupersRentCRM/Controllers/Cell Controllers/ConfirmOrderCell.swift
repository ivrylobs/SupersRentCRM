//
//  ConfirmOrderCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ConfirmOrderCell: UITableViewCell {
	
	@IBOutlet weak var orderID: UILabel!
	@IBOutlet weak var dateStart: UILabel!
	@IBOutlet weak var dateEnd: UILabel!
	@IBOutlet weak var dateCreated: UILabel!
	@IBOutlet weak var depositeAmount: UILabel!
	@IBOutlet weak var dayRent: UILabel!
	@IBOutlet weak var totalPerDay: UILabel!
	@IBOutlet weak var totalAmount: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
