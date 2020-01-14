//
//  ReturnDateSelect.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 14/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class ReturnDateSelectController: UIViewController {
	
	var productReturn: JSON?
	var whoPresentButton: String?
	
	var newJSONList: JSON?
	
	var endDate: Date?
	var endTime: Date?
	
	@IBOutlet weak var dateButton: UIButton!
	@IBOutlet weak var timeButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		hideKeyboardWhenTappedAround()
	}
	
	@IBAction func returnToView(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	@IBAction func getNewDate(_ sender: UIButton) {
		self.whoPresentButton = sender.restorationIdentifier
		self.performSegue(withIdentifier: "goGetEndDate", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goGetEndDate" {
			let vc = segue.destination as? GetEndDateController
			vc?.whoPresent = self.whoPresentButton
		} else if segue.identifier == "gotoTransport" {
			let vc = segue.destination as? ProductReturnSummaryController
			
			let customer = JSON(Locksmith.loadDataForUserAccount(userAccount: "customerInfo")!)
			let branch = JSON(Locksmith.loadDataForUserAccount(userAccount: "branch")!)
			vc?.productReturnJSON = self.newJSONList
			vc?.profileCustomer = customer["customerInfo"]
			vc?.branchJSON = branch["branchList"]
		}
	}
	@IBAction func goConfirmReturn(_ sender: UIButton) {
		
		let formatter = DateFormatter()
		formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
		formatter.calendar = Calendar(identifier: .iso8601)
		let newDate = formatter.date(from: self.productReturn!["orderContractStart"].stringValue)
		
		let calendar = Calendar.current
		
		let differnce = calendar.dateComponents([.day], from: newDate!, to: self.endDate!)
		
		var newJson = self.productReturn
		
		var countTotal = 0.0
		var allItem = 0
		for item in self.productReturn!["orderItems"].arrayValue {
			countTotal += item["totalForItem"].doubleValue
			allItem += item["productReturn"].intValue + item["productDamaged"].intValue + item["productLost"].intValue
		}
		formatter.dateFormat =  "yyyy-MM-dd'T'"
		let day = formatter.string(from: self.endDate!)
		formatter.dateFormat =  "HH:mm:ss.SSSXXX"
		let time = formatter.string(from: self.endTime!)
		
		newJson!["orderContractEnd"].stringValue = "\(day)\(time)"
		newJson!["orderAllDay"].stringValue = "\(differnce.day!)"
		newJson!["orderAllItem"].stringValue = "\(allItem)"
		newJson!["orderAllItemBalance"].intValue = self.productReturn!["orderAllItemBalance"].intValue - newJson!["orderAllItem"].intValue
		newJson!["orderAllTotalPerDay"].stringValue = "\(String(format: "%.2f", countTotal))"
		newJson!["orderAllTotal"].stringValue = "\(String(format: "%.2f", countTotal * Double(differnce.day!)))"
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let getOrderReturn = "https://api.supersrent.com/app-admin/api/orderDetailsReturn/orderDetailReturn/getOrderReturnId/\(userData["username"].stringValue)/\(self.productReturn!["id"].stringValue)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		self.pullAPI(url: getOrderReturn, method: .get, header: header) { jsonRecieve in
			newJson!["orderID"].string = "\(self.productReturn!["orderID"].stringValue)/\(jsonRecieve.count + 1)"
			print(newJson!["orderID"].string!)
			self.newJSONList = newJson
			self.performSegue(withIdentifier: "gotoTransport", sender: self)
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
