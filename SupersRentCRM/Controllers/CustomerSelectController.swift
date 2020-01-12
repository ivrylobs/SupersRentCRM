//
//  CustomerSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 11/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import PopupDialog

class CustomerSelectController: UIViewController {
	
	var customerData:[JSON]?
	var profileData: JSON?
	var selectedBranch: String?
	
	
	@IBOutlet weak var customerTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.customerTable.delegate = self
		self.customerTable.dataSource = self
		
		let cellNib = UINib(nibName: "CustomerDetailCell", bundle: nil)
		self.customerTable.register(cellNib, forCellReuseIdentifier: "CustomerDetailCell")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "customerToProfile" {
			let vc = segue.destination as! ProfileDetailController
			print("Customer: \(self.selectedBranch!)")
			vc.profileData = self.profileData
			vc.selectedBranch = self.selectedBranch
		}
	}
	
	@IBAction func goBack(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension CustomerSelectController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(80)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.customerData!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.customerTable.dequeueReusableCell(withIdentifier: "CustomerDetailCell", for: indexPath) as! CustomerDetailCell
		
		cell.customerData = self.customerData![indexPath.row]
		cell.nameLabel.text = "\(self.customerData![indexPath.row]["firstName"].stringValue) \(self.customerData![indexPath.row]["lastName"].stringValue)"
		cell.identityLabel.text = self.customerData![indexPath.row]["idcardnumber"].stringValue
		cell.phoneLabel.text = self.customerData![indexPath.row]["phone"].stringValue
		
		return cell
	}
}

extension CustomerSelectController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let title = "\(self.customerData![indexPath.row]["firstName"].stringValue) \(self.customerData![indexPath.row]["lastName"].stringValue)"
		let message = "\(self.customerData![indexPath.row]["idcardnumber"].stringValue) | \(self.customerData![indexPath.row]["phone"].stringValue)"
		
		let popup = PopupDialog(title: title, message: message)
		
		let cancelButton = CancelButton(title: "Cancel") {
			print("Cancel")
		}
		let loginButton = DefaultButton(title: "Login", dismissOnTap: true) {
			self.profileData = JSON(self.customerData![indexPath.row])
			self.performSegue(withIdentifier: "customerToProfile", sender: self)
		}
		
		popup.buttonAlignment = .horizontal
		
		
		popup.addButtons([cancelButton, loginButton])
		self.present(popup, animated: true, completion: nil)
	}
}
