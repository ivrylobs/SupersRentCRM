//
//  RentalController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class RentalController: UIViewController {
	
	var branchList: [String]?
	var selectedBranch: String?
	var customerSearch: String?
	
	
	@IBOutlet weak var identityNumber: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	@IBAction func getBranch(_ sender: UIButton) {
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let branchURL = "https://api.supersrent.com/app-admin/api/settings/company-setting/branch/\(userData["username"].stringValue)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		Alamofire.request(branchURL, method: .get, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
					case .success(let data):
						let json = JSON(data)
						var storeList:[String] = []
						//print(json)
						for item in json.arrayValue {
							storeList.append(item["branchName"].stringValue)
						}
						print(storeList)
						self.branchList = storeList
						self.performSegue(withIdentifier: "selectBranch", sender: self)
					case .failure(let error):
						print(error)
				}
			}
		}
	}
	
	@IBAction func customerSearch(_ sender: UIButton) {
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		var customerURL = ""
		
		if self.identityNumber.text != "" && self.firstName.text == "" && self.phoneNumber.text == "" {
			self.customerSearch = self.identityNumber.text
			print("Identity")
		} else if self.identityNumber.text == "" && self.firstName.text != "" && self.phoneNumber.text == "" {
			self.customerSearch = self.firstName.text
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valueName/\(userData["username"].stringValue)/\(self.customerSearch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
			print("Name")
			print(String(utf8String: self.customerSearch!.cString(using: .utf8)!)!)
		} else if self.identityNumber.text == "" && self.firstName.text == "" && self.phoneNumber.text != ""{
			self.customerSearch = self.phoneNumber.text
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valueName/\(userData["username"].stringValue)/\(self.customerSearch!)"
			print("Phone")
		}
		
		
		
		
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		Alamofire.request(customerURL, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
					case .success(let data):
						let json = JSON(data)
						print(json)
					case .failure(let error):
						print(error)
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "selectBranch" {
			let vc = segue.destination as? BranchSelectController
			vc?.branchList = self.branchList
		}
	}
}
