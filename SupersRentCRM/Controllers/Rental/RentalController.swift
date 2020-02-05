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
import PopupDialog

class RentalController: UIViewController {
	
	var branchList: [String]?
	var branchJSON: JSON?
	var selectedBranch: String?
	
	var customerList: [JSON]?
	var customerSearch: String?
	
	
	
	@IBOutlet weak var identityNumber: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var phoneNumber: UITextField!
	
	@IBOutlet weak var getBranchButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.firstName.delegate = self
		self.identityNumber.delegate = self
		self.phoneNumber.delegate = self
		
		hideKeyboardWhenTappedAround()
		
	}
	
	
	@IBAction func getBranch(_ sender: UIButton) {
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let branchURL = "https://api.supersrent.com/app-admin/api/settings/company-setting/branch/\(userData["username"].stringValue)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		self.pullAPI(url: branchURL, method: .get, header: header, errorHandler: {
			let alert = PopupDialog(title: "ผิดพลาด", message: "กรุณาตรวจสอบข้อมูลใหม่")
			let okButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
			alert.addButton(okButton)
			self.present(alert, animated: true, completion: nil)
		}) { json in
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
		}
	}
	
	@IBAction func customerSearch(_ sender: UIButton) {
		
		if self.selectedBranch != nil {
			let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
			let userData = JSON(data)
			
			var customerURL = ""
			
			if self.identityNumber.text != "" && self.firstName.text == "" && self.phoneNumber.text == "" {
				self.customerSearch = self.identityNumber.text
				customerURL = ""
			} else if self.identityNumber.text == "" && self.firstName.text != "" && self.phoneNumber.text == "" {
				self.customerSearch = self.firstName.text
				customerURL = "https://api.supersrent.com/app-admin/api/customer/valueName/\(userData["username"].stringValue)/\(self.customerSearch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
			} else if self.identityNumber.text == "" && self.firstName.text == "" && self.phoneNumber.text != ""{
				self.customerSearch = self.phoneNumber.text
				customerURL = "https://api.supersrent.com/app-admin/api/customer/valuePhone/\(userData["username"].stringValue)/\(self.customerSearch!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
			}
			
			
			let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
			
			
			self.pullAPI(url: customerURL, method: .get, header: header, errorHandler: {
				
				let alert = PopupDialog(title: "ผิดพลาด", message: "กรุณาตรวจสอบข้อมูลใหม่")
				let okButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
				alert.addButton(okButton)
				self.present(alert, animated: true, completion: nil)
				
			}) { json in
				self.customerList = json.arrayValue
				self.performSegue(withIdentifier: "rentToCustomer", sender: self)
			}
		} else {
			let alert = PopupDialog(title: "ผิดพลาด", message: "กรุณาเลือก สาขา ที่ต้องการ")
			let okButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
			alert.addButton(okButton)
			self.present(alert, animated: true, completion: nil)
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
	
	func pullAPI(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil, errorHandler: @escaping () -> Void, handler: @escaping (JSON) -> Void)	 {
		if parameters != nil && header == nil {
			Alamofire.request(url, method: method, parameters: parameters!, encoding: JSONEncoding.default).responseJSON { response in
				DispatchQueue.main.async {
					switch response.result {
					case .success(let data):
						let json = JSON(data)
						handler(json)
					case .failure(let error):
						errorHandler()
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
						errorHandler()
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
						errorHandler()
						print("API: Pulling failed with error!")
						print("API Error: \(error)")
					}
				}
			}
		}
	}
}

extension RentalController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		print("Rental: \(textField.restorationIdentifier!) are editing.")
	}
}
