//
//  DashboardController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class DashboardController: UIViewController {
	
	var orderTotalDetail: Double = 0.0
	var orderTotalReturn: Double = 0.0
	
	@IBOutlet weak var detailAmount: UILabel!
	@IBOutlet weak var detailTotal: UILabel!
	
	@IBOutlet weak var returnAmount: UILabel!
	@IBOutlet weak var returnTotal: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.pullOrderDetailData()
		
	}
	
	func pullOrderDetailData() {
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		let urlOrderDetail = "https://api.supersrent.com/app-admin/api/orderDetails/getOrderDetail/\(userData["username"].stringValue)"
		let header:HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		Alamofire.request(urlOrderDetail, method: .get, headers: header).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
				case .success(let data):
					let json = JSON(data)
					//print(json)
					self.detailAmount.text = "\(json.count)"
					var detailAmount: Double = 0.0
					for item in json.arrayValue {
						for order in item["orderItems"].arrayValue {
							//print(order["totalForItem"].stringValue)
							detailAmount += order["totalForItem"].doubleValue
						}
					}
					//print(detailAmount)
					self.orderTotalDetail = detailAmount
					self.detailTotal.text = String(format: "%.2f", self.orderTotalDetail)
					
					let urlOrderReturn = "https://api.supersrent.com/app-admin/api/orderDetailsReturn/\(userData["username"].stringValue)"
					Alamofire.request(urlOrderReturn, method: .get, headers: header).responseJSON { response in
						DispatchQueue.main.async {
							switch response.result {
							case .success(let data):
								let json = JSON(data)
								//print(json)
								self.returnAmount.text = "\(json.count)"
								var returnAmount: Double = 0.0
								for item in json.arrayValue {
									returnAmount += item["orderAllTotal"].doubleValue
								}
								//print(returnAmount)
								self.orderTotalReturn = returnAmount
								self.returnTotal.text = String(format: "%.2f", self.orderTotalReturn)
							case .failure(let error):
								print(error)
							}
						}
					}
					
				case .failure(let error):
					print(error)
				}
			}
		}
		
		
	}
}
