//
//  GetEndDateController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 14/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit

class GetEndDateController: UIViewController {
	
	var whoPresent: String?
	
	@IBOutlet weak var datePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if whoPresent! == "endDate" {
			self.datePicker.datePickerMode = .date
			self.datePicker.calendar = Calendar(identifier: .iso8601)
		} else if whoPresent! == "startTime" {
			self.datePicker.datePickerMode = .time
			self.datePicker.calendar = Calendar(identifier: .iso8601)
		}
	}
	
	@IBAction func getBackSendDate(_ sender: UIButton) {
		let calendar = Calendar(identifier: .buddhist)
		
		let presenter = self.presentingViewController as! ReturnDateSelectController
		if whoPresent! == "endDate" {
			presenter.endDate = self.datePicker.date
			
			let day = calendar.component(.day, from: self.datePicker.date)
			let month = calendar.component(.month, from: self.datePicker.date)
			let year = calendar.component(.year, from: self.datePicker.date)
			
			let formattedDate = "  \(day)-\(month)-\(year)"
			presenter.dateButton.setTitle(formattedDate, for: .normal)
		} else if whoPresent! == "endTime" {
			presenter.endTime = self.datePicker.date
			let hour = calendar.component(.hour, from: self.datePicker.date)
			let min = calendar.component(.minute, from: self.datePicker.date)
			let sec = calendar.component(.second, from: self.datePicker.date)
			let formattedTime = "  \(hour):\(min):\(sec)"
			presenter.timeButton.setTitle(formattedTime, for: .normal)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
}
