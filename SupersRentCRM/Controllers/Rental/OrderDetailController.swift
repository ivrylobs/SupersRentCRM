//
//  OrderDetailController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import DropDown
import Locksmith
import Alamofire
import IHKeyboardAvoiding

class OrderDetailController: UIViewController {
	
	var startTime: Date?
	var endTime: Date?
	var startData: Date?
	var endDate: Date?
	var orderID: String?
	var senderID: String?
	var jsonBranch: JSON?
	var projectType: String?
	var orderCount: Int?
	var productOrders: [JSON]?
	var selectedBranch: String?
	
	@IBOutlet weak var startDateButton: UIButton!
	@IBOutlet weak var endDateButton: UIButton!
	@IBOutlet weak var startTimeButton: UIButton!
	@IBOutlet weak var endTimeButton: UIButton!
	@IBOutlet weak var occupantDropDown: UIButton!
	
	@IBOutlet weak var bearAmountText: UITextField!
	@IBOutlet weak var locationText: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		
		KeyboardAvoiding.avoidingView = self.locationText
		KeyboardAvoiding.avoidingView = self.bearAmountText
		
		KeyboardAvoiding.paddingForCurrentAvoidingView = CGFloat(50)
		print(self.productOrders! )
	}
	
	@IBAction func goBack(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	

	@IBAction func dateTimerPick(_ sender: UIButton) {
		self.senderID = sender.restorationIdentifier
		self.performSegue(withIdentifier: "orderToPicker", sender: self)
	}
	
	@IBAction func occupantDropDown(_ sender: Any) {
		let dropDown = DropDown()
		dropDown.anchorView = self.occupantDropDown
		dropDown.dataSource = ["บ้านพักอาศัย 1 ชั้น", "บ้านพักอาศัย 2 ชั้น", "อาคารพาณิช 1 ชั้น", "อาคารพาณิช 2 ชั้น", "อาคารพาณิช 3 ชั้น", "อาคารพาณิช 4 ชั้น", "อาคารสูง", "อื่นๆ"]
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			self.occupantDropDown.setTitle(item, for: .normal)
			self.projectType = item
		}
		dropDown.show()
	}
	
	@IBAction func getConfirmDetail(_ sender: Any) {
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let productURL = "https://api.supersrent.com/app-admin/api/orderDetails/orderDetail/getOrderDetail/\(userData["username"].stringValue)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		self.pullAPI(url: productURL, method: .get, header: header) { json in
			
			let branch = Locksmith.loadDataForUserAccount(userAccount: "branch")
			let branchList = JSON(branch!["branchList"]!)
			
			//Get Today Date.
			let date = Date()
			
			let calendar = Calendar(identifier: .buddhist)
			
			let year = calendar.component(.year, from: date)
			let month = calendar.component(.month, from: date)
			
			//Last order + 1 run number.
			self.orderCount = json.count + 1
			
			
			for item in branchList.arrayValue {
				if self.selectedBranch == item["branchName"].stringValue {
					self.jsonBranch = item
					if month < 10 {
						
						//For day in month below date 10.
						self.orderID = "\(item["branchid"].stringValue)\(year)0\(month)/\(json.count + 1)"
					} else {
						self.orderID = "\(item["branchid"].stringValue)\(year)\(month)/\(json.count + 1)"
					}
					break
				}
			}
			
			if self.orderID != nil {
				
				print("Order Detail: \(self.orderID!)")
				self.performSegue(withIdentifier: "orderToConfirm", sender: self)
				
			} else {
				
				print("Order: Fail to generate OrderID")
				
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "orderToPicker" {
			
			let vc = segue.destination as! TimePickerController
			vc.senderID = self.senderID
			
		} else if segue.identifier == "orderToConfirm" {
			
			let vc = segue.destination as! ConfirmOrderController
			
			vc.productOrders = self.productOrders
			vc.orderID = self.orderID
			vc.jsonBranch = self.jsonBranch
			vc.startDate = self.startData
			vc.endDate = self.endDate
			vc.startTime = self.startTime
			vc.endTime = self.endTime
			vc.depositeAmount = Int(self.bearAmountText.text!)
			vc.orderLocation = self.locationText.text!
			vc.projectType = self.projectType
			vc.orderCount = self.orderCount
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
