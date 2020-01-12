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
		dropDown.dataSource = ["บ้านพักอาศัย 1 ชั้น0", "บ้านพักอาศัย 2 ชั้น", "อาคารพาณิช 1 ชั้น", "อาคารพาณิช 2 ชั้น", "อาคารพาณิช 3 ชั้น", "อาคารพาณิช 4 ชั้น", "อาคารสูง", "อื่นๆ"]
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
		
		Alamofire.request(productURL, method: .get, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
				case .success(let data):
					let json = JSON(data)
					let branch = Locksmith.loadDataForUserAccount(userAccount: "branch")
					let branchList = JSON(branch!["branchList"]!)
					let date = Date()
					let calendar = Calendar(identifier: .buddhist)
					let year = calendar.component(.year, from: date)
					let month = calendar.component(.month, from: date)
					self.orderCount = json.count + 1
					for item in branchList.arrayValue {
						if self.selectedBranch == item["branchName"].stringValue {
							self.jsonBranch = item
							if month < 10 {
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
				case .failure(let error):
					print("Order: ", error)
				}
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
}
