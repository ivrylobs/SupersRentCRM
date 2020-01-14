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
import IHKeyboardAvoiding

class RentalController: UIViewController {
	
	var branchList: [String]?
	var customerList: [JSON]?
	var selectedBranch: String?
	var customerSearch: String?
	var branchJSON: JSON?
	
	
	@IBOutlet weak var identityNumber: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	
	@IBOutlet weak var getBranchButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		hideKeyboardWhenTappedAround()
		KeyboardAvoiding.avoidingView = self.firstName
		KeyboardAvoiding.avoidingView = self.identityNumber
		KeyboardAvoiding.avoidingView = self.phoneNumber
		
		KeyboardAvoiding.paddingForCurrentAvoidingView = CGFloat(50)

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
					self.branchJSON = json
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
			vc?.branchJSONList = self.branchJSON?.arrayValue
			vc?.branchList = self.branchList
			vc?.whoPresentMe = self.restorationIdentifier!
		} else if segue.identifier == "rentToCustomer" {
			let vc = segue.destination as? CustomerSelectController
			print("Rental: \(self.selectedBranch!)")
			vc?.customerData = self.customerList
			vc?.selectedBranch = self.selectedBranch
			vc?.branchInformation = self.branchJSON
			vc?.whoPresentMe = self.restorationIdentifier
		}
	}
}
