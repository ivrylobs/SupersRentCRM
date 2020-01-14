//
//  SummaryProductReturnCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 14/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class SummaryProductReturnCell: UITableViewCell {
	
	
	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var productID: UILabel!
	@IBOutlet weak var productSize: UILabel!
	@IBOutlet weak var productPrice: UILabel!
	@IBOutlet weak var productQuantity: UILabel!
	@IBOutlet weak var productReturn: UILabel!
	@IBOutlet weak var productDamaged: UILabel!
	@IBOutlet weak var productLost: UILabel!
	@IBOutlet weak var productBalance: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
