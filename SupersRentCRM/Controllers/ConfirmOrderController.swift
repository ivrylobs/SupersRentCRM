//
//  ConfirmOrderController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Locksmith
import PopupDialog
import Alamofire

class ConfirmOrderController: UIViewController {
	
	var productOrders: [JSON]?
	var orderID: String?
	var jsonBranch: JSON?
	var startDate: Date?
	var endDate: Date?
	var startTime: Date?
	var endTime: Date?
	var depositeAmount: Int?
	var orderCreatedDate: String?
	var orderLocation: String?
	var customerJSON: JSON?
	var projectType: String?
	var totalForItem: Double?
	var totalPerDay: Double?
	var itemAllCount: Int?
	var rentDay: Int?
	var orderCount: Int?
	var backDoorUsername: String?
	var orderItems:[Any] = []
	
	@IBOutlet weak var confirmTable: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.confirmTable.dataSource = self
		self.confirmTable.delegate = self
		
		let orderCellNib = UINib(nibName: "ConfirmOrderCell", bundle: nil)
		let customerCellNib = UINib(nibName: "ConfirmCustomerCell", bundle: nil)
		let branchCellNib = UINib(nibName: "ConfirmBranchCell", bundle: nil)
		let productCellNib = UINib(nibName: "ConfirmProductCell", bundle: nil)
		
		self.confirmTable.register(orderCellNib, forCellReuseIdentifier: "confirmOrderCell")
		self.confirmTable.register(customerCellNib, forCellReuseIdentifier: "confirmCustomerCell")
		self.confirmTable.register(branchCellNib, forCellReuseIdentifier: "confirmBranchCell")
		self.confirmTable.register(productCellNib, forCellReuseIdentifier: "confirmProductCell")
		
	}
	
	@IBAction func goBack(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func addOrderDetail(_ sender: UIButton) {
		
		let popup = PopupDialog(title: "ยืนยันการเช่า", message: "ยืนยันที่จะเช่าสินค้าหรือไม่?")
		popup.buttonAlignment = .horizontal
		let confirmButton = DefaultButton(title: "ยืนยัน", dismissOnTap: true) {
			let formatter = DateFormatter()
			formatter.dateFormat = "HH:mm:ss"
			
			let finalOrder: [String: Any] = [
				"orderID": self.orderID!,
				"orderBranch": self.jsonBranch!["branchName"].stringValue,
				"orderDate": self.orderCreatedDate!,
				"orderLocation": self.orderLocation!,
				"orderEmployee": self.getUserName(),
				"orderAddress": self.customerJSON!["address"].stringValue,
				"orderCustomerName": "\(self.customerJSON!["firstName"].stringValue) \(self.customerJSON!["lastName"].stringValue)",
				"orderCustomerId": self.customerJSON!["idcardnumber"].stringValue,
				"orderCustomerPhone": self.customerJSON!["phone"].stringValue,
				"orderBail":"0",
				"orderSale":"\(self.depositeAmount ?? 0)",
				"orderProject": self.projectType ?? "",
				"orderContractStart": self.startDate!.description,
				"orderContractEnd": self.endDate!.description,
				"orderContractDateStart": formatter.string(from: self.startTime!),
				"orderContractDateEnd": formatter.string(from: self.endTime!),
				"orderAllTotal": String(format: "%.2f", self.totalForItem!),
				"orderAllItem": "\(self.itemAllCount!)",
				"orderAllDay": "\(self.rentDay!)",
				"orderAllTotalPerDay": String(format: "%.2f", self.totalPerDay!),
				"orderIdCount": "\(self.orderCount!)",
				"update": false,
				"orderAllItemBalance": self.itemAllCount!,
				"admin": self.backDoorUsername!,
				"orderItems": self.orderItems]
			
			let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
			let userData = JSON(data)
			let getUserURL = "https://api.supersrent.com/app-admin/api/orderDetails/orderDetail"
			let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
			self.backDoorUsername = userData["username"].stringValue
			Alamofire.request(getUserURL, method: .post, parameters: finalOrder, encoding: JSONEncoding.default, headers: header).responseJSON { response in
				DispatchQueue.main.async {
					switch response.result {
					case .success(let data):
						let json = JSON(data)
						print("Add Order Detail: \(json["message"].stringValue)")
						if json["message"].stringValue == "Order Detail Add successfully!" {
							let presenter = self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController as! UINavigationController
							presenter.viewControllers.first?.dismiss(animated: true, completion: nil)
						}
					case .failure(let error):
						print(error)
					}
				}
			}
		}
		
		let cancelButton = CancelButton(title: "ยกเลิก", dismissOnTap: true) {
			print("Confirm Order: cancel Order")
		}
		
		popup.addButtons([cancelButton, confirmButton])
		self.present(popup, animated: true, completion: nil)
	}
	
	func getUserName() -> String {
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		var employeeName = ""
		let getUserURL = "https://api.supersrent.com/app-admin/api/user-setting/getuser/\(userData["username"].stringValue)"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		self.backDoorUsername = userData["username"].stringValue
		Alamofire.request(getUserURL, method: .get, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
				case .success(let data):
					let json = JSON(data)
					employeeName = "\(json["name"].stringValue) \(json["lastname"].stringValue)"
				case .failure(let error):
					print(error)
				}
			}
		}
		return employeeName
	}
	
	
}

extension ConfirmOrderController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UILabel()
		header.backgroundColor = UIColor(rgb: 0x393D46)
		header.textColor = .white
		
		if section == 0 {
			header.text = "Order Information"
		} else if section == 1 {
			header.text = "Customer Information"
		} else if section == 2 {
			header.text = "Branch Information"
		} else if section == 3 {
			header.text = "Product Information"
		}
		return header
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var numOfCell:Int
		if section == 3 {
			numOfCell = self.productOrders!.count
		} else {
			numOfCell = 1
		}
		
		return numOfCell
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell?
		let formatter = DateFormatter()
		let calendar = Calendar.current
		formatter.dateFormat = "dd-MM-yyyy"
		let startDate = formatter.string(from: self.startDate!)
		formatter.dateFormat = "HH:mm:ss"
		let startTime = formatter.string(from: self.startTime!)
		
		formatter.dateFormat = "dd-MM-yyyy"
		let endDate = formatter.string(from: self.endDate!)
		formatter.dateFormat = "HH:mm:ss"
		let endTime = formatter.string(from: self.endTime!)
		
		formatter.dateFormat = "dd-MM-yyy HH:mm:ss"
		let createdDate = formatter.string(from: Date())
		self.orderCreatedDate = createdDate
		
		if indexPath.section == 0 {
			let orderCell = self.confirmTable.dequeueReusableCell(withIdentifier: "confirmOrderCell", for: indexPath) as! ConfirmOrderCell
			orderCell.orderID.text = self.orderID
			orderCell.dateStart.text = "\(startDate) \(startTime)"
			orderCell.dateEnd.text = "\(endDate) \(endTime)"
			orderCell.dateCreated.text = "\(createdDate)"
			orderCell.depositeAmount.text = "\(self.depositeAmount!)"
			
			let dayRentCount = calendar.dateComponents([.day], from: self.startDate!, to: self.endDate!)
			orderCell.dayRent.text = "\(dayRentCount.day!)"
			
			var sumTotalPerDay:Double = 0.0
			var countAll:Int = 0
			for item in self.productOrders! {
				sumTotalPerDay += item["productRentPrice"].doubleValue * item["productQuantity"].doubleValue
				countAll += item["productQuantity"].intValue
				
				let finalItem: [String: Any] = [
					"_id": item["id"].stringValue,
					"category": item["category"].stringValue,
					"productId": item["productId"].stringValue,
					"productSize": item["productSize"].stringValue,
					"productRentPrice": item["productRentPrice"].stringValue,
					"productPrice": item["productPrice"].stringValue,
					"productRent": "\(item["productQuantity"].intValue)",
					"productDamaged": item["productDamaged"].intValue,
					"productLost": item["productLost"].intValue,
					"productReturn": item["productReturn"].intValue,
					"productQuantity": 0,
					"productInStock": item["productInStock"].intValue - item["productQuantity"].intValue,
					"productAllStock": item["productAllStock"].intValue,
					"productBalance":item["productQuantity"].intValue,
					"productDefaultReturn": item["productDefaultReturn"].intValue,
					"productDefaultDamaged": item["productDefaultDamaged"].intValue,
					"productDefaultLost": item["productDefaultLost"].intValue,
					"totalForItem":String(format: "%.2f", item["productRentPrice"].doubleValue * item["productQuantity"].doubleValue)]
				self.orderItems.append(finalItem)
				
			}
			
			self.totalPerDay = sumTotalPerDay
			self.totalForItem = sumTotalPerDay * Double(dayRentCount.day!)
			self.itemAllCount = countAll
			self.rentDay = dayRentCount.day!
			orderCell.totalPerDay.text = String(format: "%.2f", sumTotalPerDay)
			orderCell.totalAmount.text = String(format: "%.2f", sumTotalPerDay * Double(dayRentCount.day!))
			cell = orderCell
			
		} else if indexPath.section == 1 {
			let customerCell = self.confirmTable.dequeueReusableCell(withIdentifier: "confirmCustomerCell", for: indexPath) as! ConfirmCustomerCell
			let loadedData = Locksmith.loadDataForUserAccount(userAccount: "customerInfo")
			let customerInfo = JSON(loadedData!["customerInfo"]!)
			self.customerJSON = JSON(loadedData!["customerInfo"]!)
			customerCell.customerName.text = "\(customerInfo["firstName"].stringValue) \(customerInfo["lastName"].stringValue)"
			customerCell.idCard.text = customerInfo["idcardnumber"].stringValue
			customerCell.phoneNumber.text = customerInfo["phone"].stringValue
			customerCell.customerAddress.text = customerInfo["address"].stringValue
			customerCell.addressDistrict.text = customerInfo["district"].stringValue
			customerCell.addressProvince.text = customerInfo["province"].stringValue
			cell = customerCell
			
		} else if indexPath.section == 2 {
			let branchCell = self.confirmTable.dequeueReusableCell(withIdentifier: "confirmBranchCell", for: indexPath) as! ConfirmBranchCell
			branchCell.branchName.text = self.jsonBranch!["branchName"].stringValue
			branchCell.branchPhone.text = self.jsonBranch!["branchPhone"].stringValue
			branchCell.branchAddress.text = self.jsonBranch!["branchAddress"].stringValue
			branchCell.branchDistrict.text = self.jsonBranch!["branchDistrict"].stringValue
			branchCell.branchProvince.text = self.jsonBranch!["branchProvince"].stringValue
			cell = branchCell
			
		} else if indexPath.section == 3 {
			let productCell = self.confirmTable.dequeueReusableCell(withIdentifier: "confirmProductCell", for: indexPath) as! ConfirmProductCell
			
			
			productCell.productName.text = self.productOrders![indexPath.row]["category"].stringValue
			productCell.productId.text = self.productOrders![indexPath.row]["productId"].stringValue
			productCell.productSize.text = self.productOrders![indexPath.row]["productSize"].stringValue
			productCell.rentPrice.text = String(format: "%.2f", self.productOrders![indexPath.row]["productRentPrice"].doubleValue)
			productCell.rentQuantity.text = self.productOrders![indexPath.row]["productQuantity"].stringValue
			productCell.rentTotal.text = String(format: "%.2f", self.productOrders![indexPath.row]["productRentPrice"].doubleValue * self.productOrders![indexPath.row]["productQuantity"].doubleValue)
			cell = productCell
		}
		
		return cell!
	}
	
	
}

extension ConfirmOrderController: UITableViewDelegate {
	
}
