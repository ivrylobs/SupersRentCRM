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
	
	@IBOutlet weak var productTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.productTable.dataSource = self
		self.productTable.delegate = self
		
		let cellNib = UINib(nibName: "ProductCell", bundle: nil)
		self.productTable.register(cellNib, forCellReuseIdentifier: "productCell")
		
	}
}

extension ProductSelectController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UILabel()
		header.text = self.productCategory![section]["categoryName"].stringValue
		return header
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.productCategory?.count ?? 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var productCountInSection = 0
		for item in self.productData! {
			if self.productCategory![section]["categoryName"].stringValue == item["category"].stringValue {
				productCountInSection += 1
			}
		}
		return productCountInSection
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.productTable.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
		return cell
	}
	
	
}

extension ProductSelectController: UITableViewDelegate {
	
}
