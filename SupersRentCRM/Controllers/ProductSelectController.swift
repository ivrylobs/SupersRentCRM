//
//  ProductSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 11/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class ProductSelectController: UIViewController {
	
	var productData: [JSON]?
	var selectedBranch: String?
	var productCategory: [JSON]?
	var selectedProduct: [JSON] = []
	
	@IBOutlet weak var productTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.productTable.dataSource = self
		self.productTable.delegate = self
		
		let cellNib = UINib(nibName: "ProductCell", bundle: nil)
		self.productTable.register(cellNib, forCellReuseIdentifier: "productCell")
		
	}
	@IBAction func goBack(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func gotoProductAmount(_ sender: Any) {
		
		self.performSegue(withIdentifier: "productToAmount", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "productToAmount" {
			let vc = segue.destination as! ProductAmountController
			vc.productOrders = self.selectedProduct
			vc.selectedBranch = self.selectedBranch
		}
	}
}

extension ProductSelectController: UITableViewDataSource {
	
//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		let header = UILabel()
//		header.text = self.productCategory![section]["categoryName"].stringValue
//		return header
//	}
//
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return self.productCategory?.count ?? 1
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		var productCountInSection = 0
//		for item in self.productData! {
//			if self.productCategory![section]["categoryName"].stringValue == item["category"].stringValue {
//				productCountInSection += 1
//			}
//		}
		return self.productData!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.productTable.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
//		print(indexPath.section, indexPath.row)
//		for item in self.productData! {
//			if self.productCategory![indexPath.section]
//		}
		
		cell.categoryLabel.text = self.productData![indexPath.row]["category"].stringValue
		cell.itemIDLabel.text = self.productData![indexPath.row]["productId"].stringValue
		cell.sizeLabel.text = self.productData![indexPath.row]["productSize"].stringValue
		cell.itemStock.text = self.productData![indexPath.row]["productInStock"].stringValue
		cell.rentPrice.text = self.productData![indexPath.row]["productPrice"].stringValue
		
		for item in self.selectedProduct {
			if item["productId"].stringValue == cell.itemIDLabel.text! {
				cell.isCheck = true
				cell.isSelect.image = UIImage(named: "checkmark.square.fill")
				break
			} else {
				cell.isCheck = false
				cell.isSelect.image = UIImage(named: "square")
			}
		}
		
		return cell
	}
	
}

extension ProductSelectController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ProductCell
		print("Cell: ", cell.isCheck)
		
		if cell.isCheck {
			cell.isCheck = false
		} else {
			cell.isCheck = true
		}
		if cell.isCheck {
			cell.isSelect.image = UIImage(named: "checkmark.square.fill")
		} else {
			cell.isSelect.image = UIImage(named: "square")
		}
		
		if cell.isCheck {
			self.selectedProduct.append(self.productData![indexPath.row])
			self.selectedProduct[self.selectedProduct.count - 1]["productQuantity"].int! = 1
		} else {
			if self.selectedProduct.count != 0 {
				for i in 0..<self.selectedProduct.count {
					if self.selectedProduct[i]["id"].stringValue == self.productData![indexPath.row]["id"].stringValue {
						self.selectedProduct.remove(at: i)
						break
					}
				}
			}
		}
		print("Cell: ", cell.isCheck)
		print(self.selectedProduct.count)
	}
}