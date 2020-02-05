//
//  ReturnItemController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith
import UIKit

class ReturnItemController: UIViewController {
	
	
	@IBOutlet weak var getBranchButton: UIButton!
	@IBOutlet weak var identityNumber: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	
	@IBOutlet weak var getUserLogin: UIButton!
	
	var userDataJSON: JSON?
	var httpHeader: HTTPHeaders?
	var branchJSON: JSON?
	
	//BranchSelector required value
	var branchList: [String]?
	var branchJSONList: [JSON]?
	
	//CustomerSelect required value
	var customerList: [JSON]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let loaddedData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		self.userDataJSON = JSON(loaddedData!)
		
		self.httpHeader = ["Accept":"application/json","Authorization": self.userDataJSON!["tokenAccess"].stringValue]
		
		hideKeyboardWhenTappedAround()
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "returnToBranch" {
			let destination = segue.destination as! BranchSelectController
			destination.branchJSONList = self.branchJSONList
			destination.branchList = self.branchList
			destination.whoPresentMe = self.restorationIdentifier!
		} else if segue.identifier == "returnToCustomerSelect" {
			let destination = segue.destination as! CustomerSelectController
			destination.customerData = self.customerList
			destination.selectedBranch = self.branchJSON!["branchName"].stringValue
			destination.branchInformation = self.branchJSON
			destination.whoPresentMe = self.restorationIdentifier
		}
	}
	

	@IBAction func loginWithUser(_ sender: UIButton) {
		
		var customerURL = ""
		
		if self.identityNumber.text != "" && self.firstName.text == "" && self.phoneNumber.text == "" {
			
		} else if self.identityNumber.text == "" && self.firstName.text != "" && self.phoneNumber.text == "" {
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valueName/\(self.userDataJSON!["username"].stringValue)/\(self.firstName.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		} else if self.identityNumber.text == "" && self.firstName.text == "" && self.phoneNumber.text != ""{
			customerURL = "https://api.supersrent.com/app-admin/api/customer/valuePhone/\(self.userDataJSON!["username"].stringValue)/\(self.phoneNumber.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
		}
		
		self.pullAPI(url: customerURL, method: .get, header: self.httpHeader) { recievedJSON in
			self.customerList = recievedJSON.arrayValue
			self.performSegue(withIdentifier: "returnToCustomerSelect", sender: self)
		}
	}
	
	@IBAction func getBranchList(_ sender: UIButton) {
		
		let branchURL = "https://api.supersrent.com/app-admin/api/settings/company-setting/branch/\(self.userDataJSON!["username"].stringValue)"
		
		self.pullAPI(url: branchURL, method: .get, header: self.httpHeader) { recievedJSON in
			self.branchJSONList = recievedJSON.arrayValue
			
			var storedString:[String] = []
			
			for item in recievedJSON.arrayValue {
				storedString.append(item["branchName"].stringValue)
			}
			
			self.branchList = storedString
			self.performSegue(withIdentifier: "returnToBranch", sender: self)
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
