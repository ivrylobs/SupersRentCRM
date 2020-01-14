//
//  TransportCell.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 14/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit

protocol TransportCellDelegate {
	func didChnageAmount(amount: [Any])
}

class TransportCell: UITableViewCell, UITextFieldDelegate {

	@IBOutlet weak var cost: UITextField!
	@IBOutlet weak var amount: UITextField!
	@IBOutlet weak var promotion: UITextField!
	
	var delegate: TransportCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.cost.delegate = self
		self.amount.delegate = self
		self.promotion.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		if textField.restorationIdentifier == "cost" {
			if string == "" {
				self.delegate?.didChnageAmount(amount: [0.0, self.amount.text!, self.promotion.text!])
			} else {
				self.delegate?.didChnageAmount(amount: ["\(self.cost.text!)\(string)", self.amount.text!, self.promotion.text!])
			}
		} else if textField.restorationIdentifier == "amount" {
			if string == "" {
				self.delegate?.didChnageAmount(amount: [self.cost.text!, 0.0, self.promotion.text!])
			} else {
				self.delegate?.didChnageAmount(amount: [self.cost.text!, "\(self.amount.text!)\(string)", self.promotion.text!])
			}
		} else if textField.restorationIdentifier == "promotion" {
			if string == "" {
				self.delegate?.didChnageAmount(amount: [self.cost.text!, self.amount.text!, 0.0])
			} else {
				self.delegate?.didChnageAmount(amount: [ self.cost.text!, self.amount.text!, "\(self.promotion.text!)\(string)"])
			}
		}
		
		return true
	}
    
}
