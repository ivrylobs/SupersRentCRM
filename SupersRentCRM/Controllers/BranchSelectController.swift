//
//  BranchSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit

class BranchSelectController: UIViewController {
	
	var branchList: [String]?
	
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
		let childVC = parentVC?.viewControllers![0] as? RentalController
		
		childVC?.selectedBranch = self.branchList![indexPath.row]
		
		self.dismiss(animated: true, completion: nil)
	}
}
