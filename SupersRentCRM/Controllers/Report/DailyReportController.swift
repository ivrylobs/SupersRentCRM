//
//  DailyReportController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 15/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class DailyReportController: UIViewController {
	
	
	@IBOutlet weak var reportTable: UITableView!
	
	var tableData: JSON?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.reportTable.delegate = self
		self.reportTable.dataSource = self
		
		let cell = UINib(nibName: "DailyReportCell", bundle: nil)
		self.reportTable.register(cell, forCellReuseIdentifier: "dailyReportCell")
		
		let data = Locksmith.loadDataForUserAccount(userAccount: "admin")!
		let userData = JSON(data)
		let header:HTTPHeaders = ["Accept":"application/json","Authorization": userData["tokenAccess"].stringValue]
		let dailyReportURL = "https://api.supersrent.com/app-admin/api/orderDetails/getOrderDetail/\(userData["username"].stringValue)"
		
		self.pullAPI(url: dailyReportURL, method: .get, header: header) { json in
			print(json)
			self.tableData = json
			
			self.reportTable.reloadData()
			
		}
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

extension DailyReportController: UITableViewDelegate {
	
	
}

extension DailyReportController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.tableData?.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var returnCell: UITableViewCell?
		
		let cell = self.reportTable.dequeueReusableCell(withIdentifier: "dailyReportCell", for: indexPath) as? DailyReportCell
		
		if self.tableData?.count == nil {
			returnCell = UITableViewCell()
		} else {
			
			let formatter = DateFormatter()
			//		formatter.locale = Locale(identifier: "th_TH")
			//		formatter.calendar = Calendar(identifier: .buddhist)

			
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
			let date = formatter.date(from: self.tableData![indexPath.row]["orderContractStart"].stringValue)
			formatter.dateFormat = "dd-MM-yyyy"
			let startDate = formatter.string(from: date!)
			
			cell?.customerName.text = self.tableData![indexPath.row]["orderCustomerName"].stringValue
			cell?.orderID.text = self.tableData![indexPath.row]["orderID"].stringValue
			cell?.dateStart.text = self.tableData![indexPath.row]["orderDate"].stringValue
			cell?.orderDate.text = startDate
			cell?.orderBranch.text = self.tableData![indexPath.row]["orderBranch"].stringValue
			cell?.orderEmployee.text = self.tableData![indexPath.row]["orderEmployee"].stringValue
			cell?.orderPrice.text = String(format: "%.2f บาท", self.tableData![indexPath.row]["orderAllTotal"].doubleValue)
			cell?.dateLeft.text = "0"
			
			returnCell = cell
		}
		
		
		return returnCell!
	}
	
	
}

