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
	var customerList: [JSON]?
	var selectedBranch: String?
	var customerSearch: String?
	
	
	@IBOutlet weak var identityNumber: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hideKeyboardWhenTappedAround()
		
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
					
					do {
						try Locksmith.saveData(data: ["branchList": json.arrayObject!], forUserAccount: "branch")
						print(Locksmith.loadDataForUserAccount(userAccount: "branch")!)
					} catch {
						print("Locksmith: ", error)
						do {
							try Locksmith.updateData(data: ["branchList": json.arrayObject!], forUserAccount: "branch")
							print("Locksmith: success")
						} catch {
							print("Locksmith: ", error)
						}
					}
					
					var storeList:[String] = []

					for item in json.arrayValue {
						storeList.append(item["branchName"].stringValue)
					}

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
		} else if self.identityNumber.text == "" && self.firstName.text != "" && self.phoneNumber.text == "" {
			self.customerSearch = self.firstName.text
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valueName/\(userData["username"].stringValue)/\(self.customerSearch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		} else if self.identityNumber.text == "" && self.firstName.text == "" && self.phoneNumber.text != ""{
			self.customerSearch = self.phoneNumber.text
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valuePhone/\(userData["username"].stringValue)/\(self.customerSearch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		}
		
		
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		Alamofire.request(customerURL, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
				case .success(let data):
					let json = JSON(data)
					self.customerList = json.arrayValue
					self.performSegue(withIdentifier: "rentToCustomer", sender: self)
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
		} else if segue.identifier == "rentToCustomer" {
			let vc = segue.destination as? CustomerSelectController
			print("Rental: \(self.selectedBranch!)")
			vc?.customerData = self.customerList
			vc?.selectedBranch = self.selectedBranch
		}
	}
}
