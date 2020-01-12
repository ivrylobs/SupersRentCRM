//
//  ProductAmountController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProductAmountController: UIViewController {
	
	var productOrders: [JSON]?
	var selectedBranch: String?
	
	@IBOutlet weak var productAmountTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.productAmountTable.dataSource = self
		self.productAmountTable.delegate = self
		
		let cellNib = UINib(nibName: "ProductAmountCell", bundle: nil)
		self.productAmountTable.register(cellNib, forCellReuseIdentifier: "productAmountCell")
	}
	
	@IBAction func goBack(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func gotoOrderDetail(_ sender: Any) {
		print("Changing")
		self.performSegue(withIdentifier: "gotoDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "gotoDetail" {
			let vc = segue.destination as! OrderDetailController
			vc.productOrders = self.productOrders
			vc.selectedBranch = self.selectedBranch
		}
	}
	
}

extension ProductAmountController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.productOrders!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.productAmountTable.dequeueReusableCell(withIdentifier: "productAmountCell", for: indexPath) as! ProductAmountCell
		cell.categoryLabel.text = self.productOrders![indexPath.row]["category"].stringValue
		cell.productID.text = self.productOrders![indexPath.row]["productId"].stringValue
		cell.productSize.text = self.productOrders![indexPath.row]["productSize"].stringValue
		cell.productStock.text = self.productOrders![indexPath.row]["productInStock"].stringValue
		cell.productPrice.text = self.productOrders![indexPath.row]["productPrice"].stringValue
		cell.amountLabel.text = self.productOrders![indexPath.row]["productQuantity"].stringValue
		cell.delegate = self
		
		
		for item in self.productOrders! {
			if item["productId"].stringValue == cell.productID.text! {
				cell.amountLabel.text = item["productQuantity"].stringValue
				break
			}
		}
		
		return cell
	}
	
}

extension ProductAmountController: UITableViewDelegate {
	
}

extension ProductAmountController: ProductAmountCellDelegate {
	func didChangeAmount(id: String, inputType: String, cell: ProductAmountCell) {
		print(id, inputType)
		
		for i in 0..<self.productOrders!.count {
			if id == self.productOrders![i]["productId"].stringValue {
				if inputType == "increase" {
					self.productOrders![i]["productQuantity"].int! += 1
					cell.amountLabel.text = "\(self.productOrders![i]["productQuantity"].int!)"
				} else if inputType == "decrease" {
					if self.productOrders![i]["productQuantity"].int! > 1 {
						self.productOrders![i]["productQuantity"].int! -= 1
						cell.amountLabel.text = "\(self.productOrders![i]["productQuantity"].int!)"
					} else if self.productOrders![i]["productQuantity"].int! == 1 {
						self.productOrders![i]["productQuantity"].int! -= 1
						self.productOrders?.remove(at: i)
						self.productAmountTable.reloadData()
					}
				} else {
					self.productOrders?.remove(at: i)
					self.productAmountTable.reloadData()
				}
				break
			}
		}
	}
}
