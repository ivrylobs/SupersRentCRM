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
	
	//Initial data to passing to segue destination.
	var productData: [JSON]?
	var categoryData: [JSON]?
	var productReturnData: [JSON]?
	
	//Given data from view heirichy.
	var profileData: JSON?
	var selectedBranch: String?
	var selectedBranchJSON: JSON?
	var whoPresentMe: String?
	
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
	@IBAction func goBack(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func gotoProduct(_ sender: Any) {
		
		print("Profile: Pulling product data")
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let productURL = "https://api.supersrent.com/app-admin/api/product/product-list/branch/\(userData["username"].stringValue)/\(self.selectedBranch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		let productReturnURL = "https://api.supersrent.com/app-admin/api/orderDetails//orderDetail/getOrderDetail/return/\(userData["username"].stringValue)/\(self.profileData!["idcardnumber"].stringValue)"
		let productCategoryURL = "https://api.supersrent.com/app-admin/api/product/category-list/\(userData["username"].stringValue)/\(self.selectedBranch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		if self.whoPresentMe == "RentalItem" {
			self.pullAPI(url: productURL, method: .get, header: header) { recievedJSON in
				self.productData = recievedJSON.arrayValue
				self.pullAPI(url: productCategoryURL, method: .get, header: header) { categoryJSON in
					self.categoryData = categoryJSON.arrayValue
					print("Profile: Pulled data complete")
					self.performSegue(withIdentifier: "profileToProduct", sender: self)
				}
			}
		} else if self.whoPresentMe == "ReturnItem" {
			self.pullAPI(url: productReturnURL, method: .get, header: header) { recievedJSON in
				self.productReturnData = recievedJSON.arrayValue
				print("Profile: Pulled Return data complete")
				self.performSegue(withIdentifier: "profileToReturnProduct", sender: self)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier! == "profileToProduct" {
			print("Profile: Passing Data to Product")
			let vc = segue.destination as? ProductSelectController
			vc?.productData = self.productData
			vc?.productCategory = self.categoryData
			vc?.selectedBranch = self.selectedBranch
		} else if segue.identifier == "profileToReturnProduct" {
			let vc = segue.destination as? ProductReturnSelectController
			vc?.productReturnDataSource = self.productReturnData
			
		}
	}
	
	func pullAPI(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil, handler: @escaping (JSON) -> Void) {
		if parameters != nil && header == nil {
			Alamofire.request(url, method: method, parameters: parameters!, encoding: JSONEncoding.default).responseJSON { response in
				DispatchQueue.main.async {
					switch response.result {
					case .success(let data):
						let json = JSON(data)
						handler(json)
					case .failure(let error):
						print("API: Pulling failed with error!")
						print("API Error: \(error)")
					}
				}
			}
		} else if header != nil && parameters == nil {
			Alamofire.request(url, method: method, headers: header).responseJSON { response in
				DispatchQueue.main.async {
					switch response.result {
					case .success(let data):
						let json = JSON(data)
						handler(json)
					case .failure(let error):
						print("API: Pulling failed with error!")
						print("API Error: \(error)")
					}
				}
			}
		} else if header != nil && parameters != nil {
			Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
				DispatchQueue.main.async {
					switch response.result {
					case .success(let data):
						let json = JSON(data)
						handler(json)
					case .failure(let error):
						print("API: Pulling failed with error!")
						print("API Error: \(error)")
					}
				}
			}
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
