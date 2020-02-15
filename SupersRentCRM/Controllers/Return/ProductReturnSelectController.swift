//
//  ProductReturnSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 13/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import Locksmith
import PopupDialog

class ProductReturnSelectController: UIViewController {
	
	var productReturnDataSource: [JSON]?
	var selectedRowData: Int?
	
	@IBOutlet weak var productReturnTable: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.productReturnTable.dataSource = self
		self.productReturnTable.delegate = self
		self.productReturnTable.tableFooterView = UIView()
		
		let cellNib = UINib(nibName: "ProductReturnCell", bundle: nil)
		
		self.productReturnTable.register(cellNib, forCellReuseIdentifier: "productReturnCell")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if selectedRowData != nil {
			let vc = segue.destination as? ReturnDetailController
			vc?.returnProduct = self.productReturnDataSource![selectedRowData!]
		} else {
			let alert = PopupDialog(title: "ผิดพลาด", message: "กรุณาเลือกสินค้าอย่างน้อย 1 ชิ้น")
			let okButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
			alert.addButton(okButton)
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func gotoReturnDetail(_ sender: UIButton) {
		
		self.performSegue(withIdentifier: "returnProductToDetail", sender: self)
		
	}
	
	@IBAction func backToProfile(_ sender: UIButton) {
		
		self.dismiss(animated: true, completion: nil)
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

extension ProductReturnSelectController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.productReturnDataSource!.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = self.productReturnTable.dequeueReusableCell(withIdentifier: "productReturnCell", for: indexPath) as! ProductReturnCell
		
		cell.orderID.text = self.productReturnDataSource![indexPath.row]["orderID"].stringValue
		cell.customerName.text = self.productReturnDataSource![indexPath.row]["orderCustomerName"].stringValue
		cell.orderBranch.text = self.productReturnDataSource![indexPath.row]["orderBranch"].stringValue
		cell.employeeName.text = self.productReturnDataSource![indexPath.row]["orderEmployee"].stringValue
		return cell
	}
	
	
}

extension ProductReturnSelectController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedRowData = indexPath.row
	}
}
