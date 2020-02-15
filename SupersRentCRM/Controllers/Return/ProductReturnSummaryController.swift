//
//  ProductReturnSummaryController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 14/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import Locksmith
import PopupDialog

class ProductReturnSummaryController: UIViewController {
	
	var productReturnJSON: JSON?
	var branchJSON: JSON?
	var profileCustomer: JSON?
	
	var transportAmount: [Any]?
	
	@IBOutlet weak var summaryTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		print(productReturnJSON!)
//		print(profileCustomer!)
//		print(branchJSON!)
		
		self.summaryTable.dataSource = self
		self.summaryTable.delegate = self
		
		hideKeyboardWhenTappedAround()
		
		let firstNib = UINib(nibName: "TransportCell", bundle: nil)
		let secondNib = UINib(nibName: "ConfirmOrderCell", bundle: nil)
		let thirdNib = UINib(nibName: "ConfirmCustomerCell", bundle: nil)
		let fourthNib = UINib(nibName: "ConfirmBranchCell", bundle: nil)
		let fiveNib = UINib(nibName: "SummaryProductReturnCell", bundle: nil)
		
		self.summaryTable.register(firstNib, forCellReuseIdentifier: "transportCell")
		self.summaryTable.register(secondNib, forCellReuseIdentifier: "confirmOrderCell")
		self.summaryTable.register(thirdNib, forCellReuseIdentifier: "confirmCustomerCell")
		self.summaryTable.register(fourthNib, forCellReuseIdentifier: "confirmBranchCell")
		self.summaryTable.register(fiveNib, forCellReuseIdentifier: "summaryProductReturnCell")
	}
	
	@IBAction func backToView(_ sender: UIButton) {
		
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func pushOrder(_ sender: UIButton) {
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		
		let pushOrderReturnURL = "https://api.supersrent.com/app-admin/api/orderDetailsReturn/orderDetailReturn"
		let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		
		var countAllitemReturn = 0
		
		for item in self.productReturnJSON!["orderItems"].arrayValue {
			countAllitemReturn += (item["productReturn"].intValue + item["productDamaged"].intValue + item["productLost"].intValue)
		}
		
		let body: [String: Any] = [
			"orderID": self.productReturnJSON!["orderID"].stringValue,
			"orderRentID": self.productReturnJSON!["id"].stringValue,
			"orderBranch": self.productReturnJSON!["orderBranch"].stringValue,
			"orderDate": self.productReturnJSON!["orderDate"].stringValue,
			"orderLocation": self.productReturnJSON!["orderLocation"].stringValue,
			"orderEmployee": self.productReturnJSON!["orderEmployee"].stringValue,
			"orderAddress": self.productReturnJSON!["orderAddress"].stringValue,
			"orderCustomerName": self.productReturnJSON!["orderCustomerName"].stringValue,
			"orderCustomerId": self.productReturnJSON!["orderCustomerId"].stringValue,
			"orderCustomerPhone": self.productReturnJSON!["orderCustomerPhone"].stringValue,
			"orderBail": self.productReturnJSON!["orderBail"].stringValue,
			"orderSale": self.productReturnJSON!["orderSale"].stringValue,
			"orderContractStart": self.productReturnJSON!["orderContractStart"].stringValue,
			"orderContractEnd": self.productReturnJSON!["orderContractEnd"].stringValue,
			"orderContractDateStart": self.productReturnJSON!["orderContractDateStart"].stringValue,
			"orderContractDateEnd": self.productReturnJSON!["orderContractDateEnd"].stringValue,
			"orderAllTotal": self.productReturnJSON!["orderAllTotal"].stringValue,
			"orderAllTotalPro": "\(self.productReturnJSON!["orderAllTotal"].doubleValue + (JSON(self.transportAmount![0]).doubleValue * JSON(self.transportAmount![1]).doubleValue) - JSON(self.transportAmount![2]).doubleValue)",
			"orderAllItem": self.productReturnJSON!["orderAllItem"].stringValue,
			"orderAllItemReturn": countAllitemReturn,
			"orderAllDay": self.productReturnJSON!["orderAllDay"].stringValue,
			"orderAllTotalPerDay": self.productReturnJSON!["orderAllTotalPerDay"].stringValue,
			"orderIdCount": self.productReturnJSON!["orderIdCount"].stringValue,
			"update": false,
			"orderLogistic": JSON(self.transportAmount![1]).intValue,
			"orderLogisticAmount": JSON(self.transportAmount![1]).intValue,
			"orderLogisticTotal": JSON(self.transportAmount![1]).intValue * JSON(self.transportAmount![1]).intValue,
			"orderPromotion": JSON(self.transportAmount![2]).intValue,
			"orderAllItemBalance": self.productReturnJSON!["orderAllItemBalance"].intValue - countAllitemReturn,
			"admin": self.productReturnJSON!["admin"].stringValue,
			"orderProject": self.productReturnJSON!["orderProject"].stringValue,
			"orderItemReturn": self.productReturnJSON!["orderItems"].arrayObject!
		]
		
		print(JSON(body))
		
		let popup = PopupDialog(title: "ยืนยันการทำรายการ", message: "กรุณายืนยันการแก้ไข")
		let cancelButton = CancelButton(title: "ยกเลิก", dismissOnTap: true, action: nil)
		
		let continueButton = DefaultButton(title: "ตกลง", dismissOnTap: true) {
			self.pullAPI(url: pushOrderReturnURL, method: .post, parameters: body, header: header) { recievedJSON in
				if recievedJSON["message"].stringValue != "" {
					
					print("Push ReturnItem: Success")
					
					var updateCount = 0
					
					for item in self.productReturnJSON!["orderItems"].arrayValue {
						let returnOrderUpdateStock = "https://api.supersrent.com/app-admin/api/orderDetailsReturn/orderDetailReturn/update/\(userData["username"].stringValue)/\(item["id"].stringValue)"
						let returnStockBody:[String: Any] = ["productDefaultReturn": item["productReturn"].stringValue, "productDefaultDamaged": item["productDamaged"].stringValue, "productDefaultLost": item["productLost"].stringValue]
						self.pullAPI(url: returnOrderUpdateStock, method: .put, parameters: returnStockBody, header: header) { stockReturnJSON in
							print(stockReturnJSON)
							updateCount += 1
							
							if updateCount == self.productReturnJSON!["orderItems"].count {
								print("Initialize: Update Stock Return Quantity.")
								let header: HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
								
								if self.productReturnJSON!["orderAllItem"].intValue == countAllitemReturn {
									
									let updateTrueOrderReturnURL = "https://api.supersrent.com/app-admin/api/orderDetails/orderDetail/updateOrder/\(userData["username"])/\(self.productReturnJSON!["id"].stringValue)"
									let updateBody: [String: Any] = ["orderItems": self.productReturnJSON!["orderItems"].arrayObject!, "update": true]
									
									self.pullAPI(url: updateTrueOrderReturnURL, method: .put, parameters: updateBody, header: header) { json in
										print(json)
									}
								} else {
									
									let updateFalseOrderReturnURL = "https://api.supersrent.com/app-admin/api/orderDetails/orderDetail/updateOrders/\(userData["username"])/\(self.productReturnJSON!["id"].stringValue)"
									let updateFalseBody: [String: Any] = ["orderItems": self.productReturnJSON!["orderItems"].arrayObject!, "orderAllItem": JSON(body)["orderAllItemBalance"].stringValue]
									
									self.pullAPI(url: updateFalseOrderReturnURL, method: .put, parameters: updateFalseBody, header: header) { json in
										print(json)
									}
								}
							} else {
								print("In process to update stock quantity.")
							}
						}
					}
					
					
				} else {
					print("Push ReturnItem: Failed")
				}
				let presenter = self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.children[1] as! UINavigationController
				presenter.viewControllers.first?.dismiss(animated: true, completion: nil)
			}
		}
		
		popup.addButtons([cancelButton, continueButton])
		popup.buttonAlignment = .horizontal
		self.present(popup, animated: true, completion: nil)
		
	}
	
	
	func pullAPI(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil, handler: @escaping (JSON) -> Void) {
		if parameters != nil && header == nil {
			AF.request(url, method: method, parameters: parameters!, encoding: JSONEncoding.default).responseJSON { response in
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
			AF.request(url, method: method, headers: header).responseJSON { response in
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
			AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
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

extension ProductReturnSummaryController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UILabel()
		
		header.backgroundColor = .darkGray
		header.textColor = .white
		
		if section == 0 {
			header.text = "Order Confirm"
		} else if section == 1 {
			header.text = "Order Information"
		} else if section == 2 {
			header .text = "Customer Information"
		} else if section == 3 {
			header.text = "Branch Information"
		} else if section == 4 {
			header.text = "Product Information"
		}
		
		return header
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		var numberOfRow: Int?
		
		if section == 0 {
			numberOfRow = 1
		} else if section == 1 {
			numberOfRow = 1
		} else if section == 2 {
			numberOfRow = 1
		} else if section == 3 {
			numberOfRow = 1
		} else if section == 4 {
			numberOfRow = self.productReturnJSON!["orderItems"].count
		}
		
		return numberOfRow!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell?
		
		if indexPath.section == 0 {
			let first = self.summaryTable.dequeueReusableCell(withIdentifier: "transportCell", for: indexPath) as? TransportCell
			first?.delegate = self
			cell = first
		} else if indexPath.section == 1 {
			let second = self.summaryTable.dequeueReusableCell(withIdentifier: "confirmOrderCell", for: indexPath) as? ConfirmOrderCell
			second?.orderID.text = self.productReturnJSON!["orderID"].stringValue
			second?.dateStart.text = self.productReturnJSON!["orderContractStart"].stringValue
			second?.dateEnd.text = self.productReturnJSON!["orderContractEnd"].stringValue
			second?.dateCreated.text = self.productReturnJSON!["orderDate"].stringValue
			second?.depositeAmount.text = self.productReturnJSON!["orderBail"].stringValue
			second?.dayRent.text = self.productReturnJSON!["orderAllDay"].stringValue
			second?.totalPerDay.text = self.productReturnJSON!["orderAllTotalPerDay"].stringValue
			second?.totalAmount.text = self.productReturnJSON!["orderAllTotal"].stringValue
			cell = second
		} else if indexPath.section == 2 {
			let third = self.summaryTable.dequeueReusableCell(withIdentifier: "confirmCustomerCell", for: indexPath) as? ConfirmCustomerCell
			third?.customerName.text = "\(self.profileCustomer!["firstName"].stringValue) \(self.profileCustomer!["lastName"].stringValue)"
			third?.idCard.text = self.profileCustomer!["idcardnumber"].stringValue
			third?.phoneNumber.text = self.profileCustomer!["phone"].stringValue
			third?.customerAddress.text = self.profileCustomer!["address"].stringValue
			third?.addressDistrict.text = self.profileCustomer!["district"].stringValue
			third?.addressProvince.text = self.profileCustomer!["province"].stringValue
			cell = third
		} else if indexPath.section == 3 {
			let fourth = self.summaryTable.dequeueReusableCell(withIdentifier: "confirmBranchCell", for: indexPath) as? ConfirmBranchCell
			
			for item in self.branchJSON!.arrayValue {
				if item["branchName"].stringValue == self.productReturnJSON!["orderBranch"].stringValue {
					fourth?.branchName.text = item["branchName"].stringValue
					fourth?.branchPhone.text = item["branchPhone"].stringValue
					fourth?.branchAddress.text = item["branchAddress"].stringValue
					fourth?.branchDistrict.text = item["branchDistrict"].stringValue
					fourth?.branchProvince.text = item["branchProvince"].stringValue
				}
			}
			
			cell = fourth
		} else if indexPath.section == 4 {
			let fifth = self.summaryTable.dequeueReusableCell(withIdentifier: "summaryProductReturnCell", for: indexPath) as? SummaryProductReturnCell
			fifth?.productName.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["category"].stringValue
			fifth?.productID.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productId"].stringValue
			fifth?.productSize.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productSize"].stringValue
			fifth?.productPrice.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productRentPrice"].stringValue
			fifth?.productQuantity.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productRent"].stringValue
			fifth?.productReturn.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productReturn"].stringValue
			fifth?.productDamaged.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productDamaged"].stringValue
			fifth?.productLost.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productLost"].stringValue
			fifth?.productBalance.text = self.productReturnJSON!["orderItems"].arrayValue[indexPath.row]["productBalance"].stringValue
			
			cell = fifth
		}
		return cell!
	}
	
}

extension ProductReturnSummaryController: UITableViewDelegate {
	
	
}

extension ProductReturnSummaryController: TransportCellDelegate {
	func didChnageAmount(amount: [Any]) {
		print(amount)
		self.transportAmount = amount
	}

}
