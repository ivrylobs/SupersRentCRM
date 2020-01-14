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
import PopupDialog

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
		if self.selectedProduct.count > 0 {
			self.performSegue(withIdentifier: "productToAmount", sender: self)
		} else {
			let alert = PopupDialog(title: "ผิดพลาด", message: "กรุณาเลือกสินค้าอย่างน้อย 1 ชิ้น")
			let okButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
			alert.addButton(okButton)
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "productToAmount" {
			let vc = segue.destination as! ProductAmountController
			print(self.selectedProduct)
			vc.productOrders = self.selectedProduct
			vc.selectedBranch = self.selectedBranch
		}
	}
}

extension ProductSelectController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.productData!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.productTable.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
		
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
	}
}
