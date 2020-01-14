//
//  DailyReportCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 15/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class DailyReportCell: UITableViewCell {

	@IBOutlet weak var customerName: UILabel!
	@IBOutlet weak var orderID: UILabel!
	@IBOutlet weak var orderDate: UILabel!
	@IBOutlet weak var orderBranch: UILabel!
	@IBOutlet weak var orderEmployee: UILabel!
	@IBOutlet weak var dateLeft: UILabel!
	@IBOutlet weak var dateStart: UILabel!
	@IBOutlet weak var orderPrice: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
