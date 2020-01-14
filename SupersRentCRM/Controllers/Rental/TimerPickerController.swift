//
//  TimerPickerController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 12/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit

class TimePickerController: UIViewController {
	
	var senderID: String?
	
	@IBOutlet weak var timePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if senderID! == "startDate" || senderID! == "endDate" {
			self.timePicker.datePickerMode = .date
			self.timePicker.calendar = Calendar(identifier: .gregorian)
		} else if senderID! == "startTime" || senderID! == "endTime" {
			self.timePicker.datePickerMode = .time
			self.timePicker.calendar = Calendar(identifier: .gregorian)
		}
	}
	
	@IBAction func getTime(_ sender: Any) {
		let calendar = Calendar(identifier: .iso8601)
		
		print("Date: ", self.timePicker.date)
		let presenter = self.presentingViewController as! OrderDetailController
		if senderID! == "startDate" {
			presenter.startData = self.timePicker.date
			
			let day = calendar.component(.day, from: self.timePicker.date)
			let month = calendar.component(.month, from: self.timePicker.date)
			let year = calendar.component(.year, from: self.timePicker.date)
			
			let formattedDate = "  \(day)-\(month)-\(year)"
			presenter.startDateButton.setTitle(formattedDate, for: .normal)
		} else if senderID! == "endDate" {
			presenter.endDate = self.timePicker.date
			let day = calendar.component(.day, from: self.timePicker.date)
			let month = calendar.component(.month, from: self.timePicker.date)
			let year = calendar.component(.year, from: self.timePicker.date)
			
			let formattedDate = "  \(day)-\(month)-\(year)"
			presenter.endDateButton.setTitle(formattedDate, for: .normal)
		} else if senderID! == "startTime" {
			presenter.startTime = self.timePicker.date
			
			let hour = calendar.component(.hour, from: self.timePicker.date)
			let min = calendar.component(.minute, from: self.timePicker.date)
			let sec = calendar.component(.second, from: self.timePicker.date)
			let formattedTime = "  \(hour):\(min):\(sec)"
			presenter.startTimeButton.setTitle(formattedTime, for: .normal)
		} else if senderID! == "endTime" {
			presenter.endTime = self.timePicker.date
			let hour = calendar.component(.hour, from: self.timePicker.date)
			let min = calendar.component(.minute, from: self.timePicker.date)
			let sec = calendar.component(.second, from: self.timePicker.date)
			let formattedTime = "  \(hour):\(min):\(sec)"
			presenter.endTimeButton.setTitle(formattedTime, for: .normal)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
}
