//
//  ProductAmountCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

protocol ProductAmountCellDelegate {
	func didChangeAmount(id: String, inputType: String, cell: ProductAmountCell)
}

class ProductAmountCell: UITableViewCell {
	
	var delegate: ProductAmountCellDelegate?

	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var productID: UILabel!
	@IBOutlet weak var productSize: UILabel!
	@IBOutlet weak var productStock: UILabel!
	@IBOutlet weak var productPrice: UILabel!
	@IBOutlet weak var amountLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func increaseAmount(_ sender: Any) {
		self.delegate?.didChangeAmount(id: self.productID.text!, inputType: "increase", cell: self)
	}
	@IBAction func decreaseAmount(_ sender: Any) {
		self.delegate?.didChangeAmount(id: self.productID.text!, inputType: "decrease", cell: self)
	}
	@IBAction func removeProduct(_ sender: Any) {
		self.delegate?.didChangeAmount(id: self.productID.text!, inputType: "remove", cell: self)
	}
}
