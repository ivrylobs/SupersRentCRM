//
//  ProfileContactCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 11/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ProfileContactCell: UITableViewCell {

	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var districtLabel: UILabel!
	@IBOutlet weak var provinceLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
