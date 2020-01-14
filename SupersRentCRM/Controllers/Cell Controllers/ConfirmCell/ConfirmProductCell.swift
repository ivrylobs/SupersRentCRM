//
//  ConfirmProductCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ConfirmProductCell: UITableViewCell {

	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var productId: UILabel!
	@IBOutlet weak var productSize: UILabel!
	@IBOutlet weak var rentPrice: UILabel!
	@IBOutlet weak var rentQuantity: UILabel!
	@IBOutlet weak var rentTotal: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
