//
//  ReturnDetailController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import PopupDialog

class ReturnDetailController: UIViewController {
	
	var returnProduct: JSON?
	var sendingProductItem: JSON?
	
	@IBOutlet weak var productReturnDetailTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.productReturnDetailTable.dataSource = self
		self.productReturnDetailTable.delegate = self
		
		let orderCellNib = UINib(nibName: "OrderInformationCell", bundle: nil)
		let productCellNib = UINib(nibName: "ProductInformationCell", bundle: nil)
		let orderConfirmCellNib = UINib(nibName: "OrderConfirmCell", bundle: nil)
		
		self.productReturnDetailTable.register(orderCellNib, forCellReuseIdentifier: "orderInformationCell")
		self.productReturnDetailTable.register(productCellNib, forCellReuseIdentifier: "productInformationCell")
		self.productReturnDetailTable.register(orderConfirmCellNib, forCellReuseIdentifier: "orderConfirmCell")
	}
	
	@IBAction func returnView(_ sender: UIButton) {
		
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func checkReturnDamagedLost(_ sender: UIButton) {
		
		var checkCorrection = true
		
		var copyReturnProduct = self.returnProduct
		for i in 0..<self.returnProduct!["orderItems"].count {
			
			let returnAmount = self.returnProduct!["orderItems"][i]["productDefaultReturn"].intValue
			let damagedAmount = self.returnProduct!["orderItems"][i]["productDefaultDamaged"].intValue
			let lostAmount = self.returnProduct!["orderItems"][i]["productDefaultLost"].intValue
			
			
			let totalBalance = returnAmount + damagedAmount + lostAmount
			
			if totalBalance > self.returnProduct!["orderItems"][i]["productBalance"].intValue {
				
				checkCorrection = false
				
			} else {
				let totalForItem = Double(totalBalance) * self.returnProduct!["orderItems"][i]["productRentPrice"].doubleValue
				let inStock = self.returnProduct!["orderItems"][i]["productInStock"].intValue + totalBalance
				let itemBalance = self.returnProduct!["orderItems"][i]["productBalance"].intValue - totalBalance
				
				
				copyReturnProduct!["orderItems"][i]["totalForItem"].stringValue = "\(String(format: "%.2f", totalForItem))"
				copyReturnProduct!["orderItems"][i]["productInStock"].intValue = inStock
				copyReturnProduct!["orderItems"][i]["productBalance"].intValue = itemBalance
				
				copyReturnProduct!["orderItems"][i]["productReturn"].intValue = self.returnProduct!["orderItems"][i]["productDefaultReturn"].intValue
				copyReturnProduct!["orderItems"][i]["productDamaged"].intValue = self.returnProduct!["orderItems"][i]["productDefaultDamaged"].intValue
				copyReturnProduct!["orderItems"][i]["productLost"].intValue = self.returnProduct!["orderItems"][i]["productDefaultLost"].intValue
				
				copyReturnProduct!["orderItems"][i]["productDefaultReturn"].stringValue = "0"
				copyReturnProduct!["orderItems"][i]["productDefaultDamaged"].stringValue = "0"
				copyReturnProduct!["orderItems"][i]["productDefaultLost"].stringValue = "0"

			}
		}
		
		if !checkCorrection {
			let popup = PopupDialog(title: "ผิดพลาด", message: "จำนวนสินค้าที่คืนมากกว่าจำนวนที่เช่า")
			
			let okButton = DefaultButton(title: "ตกลง", dismissOnTap: true, action: nil)
			popup.addButton(okButton)
			
			self.present(popup, animated: true, completion: nil)
		} else {
			self.sendingProductItem = copyReturnProduct
			self.performSegue(withIdentifier: "gotoSelectReturnDate", sender: self)
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "gotoSelectReturnDate" {
			let vc = segue.destination as? ReturnDateSelectController
			vc?.productReturn = self.sendingProductItem
		}
	}
	
}

extension ReturnDetailController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UILabel()
		header.backgroundColor = .darkGray
		header.textColor = .white
		if section == 0 {
			header.text = "Order Information"
		} else if section == 1 {
			header.text = "Product Information"
		}
		
		return header
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var numberOfRow: Int?
		
		if section == 0 {
			numberOfRow = 1
		} else if section == 1 {
			numberOfRow = self.returnProduct!["orderItems"].count
		}
		
		return numberOfRow!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		
		if indexPath.section == 0 {
			let orderCell = self.productReturnDetailTable.dequeueReusableCell(withIdentifier: "orderInformationCell", for: indexPath) as? OrderInformationCell

			orderCell?.orderID.text = self.returnProduct!["orderID"].stringValue
			orderCell?.dateInfo.text = self.returnProduct!["orderContractStart"].stringValue
			orderCell?.branchInfo.text = self.returnProduct!["orderBranch"].stringValue
			cell = orderCell
		
		} else if indexPath.section == 1 {
			let productCell = self.productReturnDetailTable.dequeueReusableCell(withIdentifier: "productInformationCell", for: indexPath) as? ProductInformationCell

			productCell?.productName.text = self.returnProduct!["orderItems"].arrayValue[indexPath.row]["category"].stringValue
			productCell?.productId.text = self.returnProduct!["orderItems"].arrayValue[indexPath.row]["productId"].stringValue
			productCell?.productSize.text = self.returnProduct!["orderItems"].arrayValue[indexPath.row]["productSize"].stringValue
			productCell?.productPrice.text = self.returnProduct!["orderItems"].arrayValue[indexPath.row]["productRentPrice"].stringValue
			productCell?.productQuantity.text = self.returnProduct!["orderItems"].arrayValue[indexPath.row]["productBalance"].stringValue

			
			productCell?.delegate = self
			
			for item in self.returnProduct!["orderItems"].arrayValue {
				if item["productId"].stringValue == productCell?.productId.text! {
					productCell?.returnAmount.text = item["productDefaultReturn"].stringValue
					productCell?.damagedAmount.text = item["productDefaultDamaged"].stringValue
					productCell?.lostAmount.text = item["productDefaultLost"].stringValue
					break
				} else {
					productCell?.returnAmount.text = ""
					productCell?.damagedAmount.text = ""
					productCell?.lostAmount.text = ""
				}
			}
			
			cell = productCell
	
		}
		
		return cell!
	}
	
}

extension ReturnDetailController: ProductInformationCellDelegate {
	func cellDidValueChanged(cellValue: [String], cellId: String) {
		
		for i in 0..<self.returnProduct!["orderItems"].count {
			if cellId == self.returnProduct!["orderItems"].arrayValue[i]["productId"].stringValue {
				self.returnProduct!["orderItems"][i]["productDefaultReturn"].stringValue = cellValue[0]
				self.returnProduct!["orderItems"][i]["productDefaultDamaged"].stringValue = cellValue[1]
				self.returnProduct!["orderItems"][i]["productDefaultLost"].stringValue = cellValue[2]
			}
		}
	}
	
}

extension ReturnDetailController: UITableViewDelegate {
	
}
