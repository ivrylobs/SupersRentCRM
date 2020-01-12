//
//  ProductCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 11/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
	
	var isCheck: Bool = false
	
	
	@IBOutlet weak var isSelect: UIImageView!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var itemIDLabel: UILabel!
	@IBOutlet weak var sizeLabel: UILabel!
	@IBOutlet weak var itemStock: UILabel!
	@IBOutlet weak var rentPrice: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
