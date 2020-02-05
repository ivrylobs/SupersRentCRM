//
//  ProductInformationCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

protocol ProductInformationCellDelegate {
	func cellDidValueChanged(cellValue: [String], cellId: String)
}

class ProductInformationCell: UITableViewCell, UITextFieldDelegate {

	@IBOutlet weak var productName: UILabel!
	@IBOutlet weak var productId: UILabel!
	@IBOutlet weak var productSize: UILabel!
	@IBOutlet weak var productPrice: UILabel!
	@IBOutlet weak var productQuantity: UILabel!
	
	@IBOutlet weak var returnAmount: UITextField!
	@IBOutlet weak var damagedAmount: UITextField!
	@IBOutlet weak var lostAmount: UITextField!
	
	var delegate: ProductInformationCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.returnAmount.delegate = self
		self.damagedAmount.delegate = self
		self.lostAmount.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if string == "" {
			print("String are empty")
		}
		if textField.restorationIdentifier == "return" {
			if string == "" {
				self.delegate?.cellDidValueChanged(cellValue: ["", self.damagedAmount.text!, self.lostAmount.text!], cellId: self.productId.text!)
			} else {
				self.delegate?.cellDidValueChanged(cellValue: [self.returnAmount.text! + string, self.damagedAmount.text!, self.lostAmount.text!], cellId: self.productId.text!)
			}
			
		} else if textField.restorationIdentifier == "damaged" {
			if string == "" {
				self.delegate?.cellDidValueChanged(cellValue: [self.returnAmount.text!, "", self.lostAmount.text!], cellId: self.productId.text!)
			} else {
				self.delegate?.cellDidValueChanged(cellValue: [self.returnAmount.text!, self.damagedAmount.text! + string, self.lostAmount.text!], cellId: self.productId.text!)
			}
			
		} else if textField.restorationIdentifier == "lost" {
			if string == "" {
				self.delegate?.cellDidValueChanged(cellValue: [self.returnAmount.text!, self.damagedAmount.text!, ""], cellId: self.productId.text!)
			} else {
				self.delegate?.cellDidValueChanged(cellValue: [self.returnAmount.text!, self.damagedAmount.text!, self.lostAmount.text! + string], cellId: self.productId.text!)
			}
			
		}
		
		return true
	}
}
