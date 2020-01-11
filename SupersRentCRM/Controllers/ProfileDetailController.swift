//
//  ProfileDetailController.swift
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

class ProfileDetailController: UIViewController {
	
	var profileData: JSON?
	var selectedBranch: String?
	var productData: [JSON]?
	var categoryData: [JSON]?
	
	
	@IBOutlet weak var profileTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let detailCell = UINib(nibName: "ProfileDetailCell", bundle: nil)
		let contactCell = UINib(nibName: "ProfileContactCell", bundle: nil)
		
		self.profileTable.register(detailCell, forCellReuseIdentifier: "profileDetailCell")
		self.profileTable.register(contactCell, forCellReuseIdentifier: "profileContactCell")
		
		self.profileTable.dataSource = self
		self.profileTable.delegate = self
		
		self.profileTable.tableFooterView = UIView()
	}
	
	
	@IBAction func gotoProduct(_ sender: Any) {
		
		print("Profile: Pull product data")
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let productURL = "https://api.supersrent.com/app-admin/api/product/product-list/branch/\(userData["username"].stringValue)/\(self.selectedBranch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		Alamofire.request(productURL, method: .get, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
				case .success(let data):
					let productJSON = JSON(data)
					self.productData = productJSON.arrayValue
					let productURL = "https://api.supersrent.com/app-admin/api/product/category-list/\(userData["username"].stringValue)/\(self.selectedBranch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
					
					Alamofire.request(productURL, method: .get, headers: header).responseJSON { response in
						DispatchQueue.main.async {
							switch response.result {
							case .success(let data):
								let categoryJSON = JSON(data)
								self.categoryData = categoryJSON.arrayValue
								print("Profile: Pulled data complete")
								self.performSegue(withIdentifier: "profileToProduct", sender: self)
							case .failure(let error):
								print(error)
							}
						}
					}
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "profileToProduct" {
			let vc = segue.destination as? ProductSelectController
			vc?.productData = self.productData
			vc?.productCategory = self.categoryData
			vc?.selectedBranch = self.selectedBranch
		}
	}
}

extension ProfileDetailController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell?
		if indexPath.section == 0 {
			let detailCell = self.profileTable.dequeueReusableCell(withIdentifier: "profileDetailCell", for: indexPath) as! ProfileDetailCell
			detailCell.nameLabel.text = self.profileData!["firstName"].stringValue
			detailCell.idLabel.text = self.profileData!["idcardnumber"].stringValue
			detailCell.genderLabel.text = self.profileData!["gender"].stringValue
			detailCell.careerLabel.text = self.profileData!["career"].stringValue
			detailCell.branchLabel.text = self.profileData!["branch"].stringValue
			cell = detailCell
		} else {
			let contactCell = self.profileTable.dequeueReusableCell(withIdentifier: "profileContactCell", for: indexPath) as! ProfileContactCell
			contactCell.phoneLabel.text = self.profileData!["phone"].stringValue
			contactCell.emailLabel.text = self.profileData!["email"].stringValue
			contactCell.addressLabel.text = self.profileData!["address"].stringValue
			contactCell.districtLabel.text = self.profileData!["district"].stringValue
			contactCell.provinceLabel.text = self.profileData!["province"].stringValue
			cell = contactCell
		}
		
		return cell!
	}
}

extension ProfileDetailController: UITableViewDelegate {
	
}
