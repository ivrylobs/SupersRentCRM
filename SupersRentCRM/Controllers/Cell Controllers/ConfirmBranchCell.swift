//
//  ConfirmBranchCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ConfirmBranchCell: UITableViewCell {

	@IBOutlet weak var branchName: UILabel!
	@IBOutlet weak var branchPhone: UILabel!
	@IBOutlet weak var branchAddress: UILabel!
	@IBOutlet weak var branchDistrict: UILabel!
	@IBOutlet weak var branchProvince: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
