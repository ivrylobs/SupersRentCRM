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
	
	var senderID: String?
	
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
		print(sender.restorationIdentifier!)
		self.senderID = sender.restorationIdentifier
		self.performSegue(withIdentifier: "orderToPicker", sender: self)
	}
	
	@IBAction func occupantDropDown(_ sender: Any) {
		let dropDown = DropDown()
		dropDown.anchorView = self.occupantDropDown
		dropDown.dataSource = ["บ้านพักอาศัย 1 ชั้น0", "บ้านพักอาศัย 2 ชั้น", "อาคารพาณิช 1 ชั้น", "อาคารพาณิช 2 ชั้น", "อาคารพาณิช 3 ชั้น", "อาคารพาณิช 4 ชั้น", "อาคารสูง", "อื่นๆ"]
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			print("Selected item: \(item) at index: \(index)")
			self.occupantDropDown.setTitle(item, for: .normal)
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
					print(json.count)
					let branch = Locksmith.loadDataForUserAccount(userAccount: "branch")
					print(JSON(branch))
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! TimePickerController
		vc.senderID = self.senderID
	}
}
