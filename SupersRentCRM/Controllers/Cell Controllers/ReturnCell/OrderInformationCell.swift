//
//  OrderInformationCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class OrderInformationCell: UITableViewCell {
	
	
	@IBOutlet weak var orderID: UILabel!
	@IBOutlet weak var dateInfo: UILabel!
	@IBOutlet weak var branchInfo: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
