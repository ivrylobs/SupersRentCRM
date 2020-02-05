//
//  SideMenuViewController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 6/2/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuBarController: UIViewController {
	
	
	@IBOutlet weak var sideMenuTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sideMenuTable.dataSource = self
		self.sideMenuTable.delegate = self
		
		self.sideMenuTable.tableFooterView = UIView()
		self.sideMenuTable.isScrollEnabled = false
		
		self.sideMenuController?.cache(viewController: (self.storyboard?.instantiateViewController(withIdentifier: "SecondView"))!, with: "1")
		self.sideMenuController?.cache(viewController: (self.storyboard?.instantiateViewController(withIdentifier: "ThirdView"))!, with: "2")
		
	}
	
}

extension MenuBarController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.sideMenuTable.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
		
		if indexPath.row == 0 {
			cell.textLabel?.text = "Dashboard"
		} else if indexPath.row == 1 {
			cell.textLabel?.text = "Rent/Return"
		} else if indexPath.row == 2 {
			cell.textLabel?.text = "Report"
		}
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.row == 0 {
			self.sideMenuController?.setContentViewController(with: "0")
		} else if indexPath.row == 1 {
			self.sideMenuController?.setContentViewController(with: "1")
		} else if indexPath.row == 2 {
			self.sideMenuController?.setContentViewController(with: "2")
		}
		self.sideMenuController?.hideMenu()
	}
	
}
