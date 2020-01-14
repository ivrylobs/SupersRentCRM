//
//  BranchSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class BranchSelectController: UIViewController {
	
	var branchList: [String]?
	var branchJSONList: [JSON]?
	var whoPresentMe: String?
	
	@IBOutlet weak var branchTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.branchTable.delegate = self
		self.branchTable.dataSource = self
		self.branchTable.tableFooterView = UIView()
	}
}

extension BranchSelectController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.branchList?.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.branchTable.dequeueReusableCell(withIdentifier: "branchCell", for: indexPath)
		cell.textLabel?.text = self.branchList![indexPath.row]
		return cell
	}
}

extension BranchSelectController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//Get PresentingViewController By reversing CHeck parent.
		let presenter = self.presentingViewController as? UINavigationController
		let parentVC = presenter?.viewControllers.first as? UITabBarController
		
		if self.whoPresentMe == "RentalItem" {
			let childVC = parentVC?.viewControllers![0] as? RentalController
			
			for i in 0..<self.branchJSONList!.count {
				if self.branchList![indexPath.row] == self.branchJSONList![i]["branchName"].stringValue {
					childVC?.branchJSON = self.branchJSONList![i]
					break
				}
			}
			
			childVC?.selectedBranch = self.branchList![indexPath.row]
			childVC?.getBranchButton.setTitle(self.branchList![indexPath.row], for: .normal)
			
		} else if self.whoPresentMe == "ReturnItem" {
			let childVC = parentVC?.viewControllers![1] as? ReturnItemController
			
			for i in 0..<self.branchJSONList!.count {
				if self.branchList![indexPath.row] == self.branchJSONList![i]["branchName"].stringValue {
					childVC?.branchJSON = self.branchJSONList![i]
					break
				}
			}
			childVC?.getBranchButton.setTitle(self.branchList![indexPath.row], for: .normal)
			
		} else {
			print("Branch: There are no viewcontroller presenting!")
		}
		
		self.dismiss(animated: true, completion: nil)
	}
}
