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
		} else if senderID! == "startTime" || senderID! == "endTime" {
			self.timePicker.datePickerMode = .time
		}
	}
	
	@IBAction func getTime(_ sender: Any) {
		
		print(self.timePicker.date)
		let presenter = self.presentingViewController as! OrderDetailController
		if senderID! == "startDate" {
			presenter.startData = self.timePicker.date
			presenter.startDateButton.setTitle(self.timePicker.date.description, for: .normal)
		} else if senderID! == "endDate" {
			presenter.endDate = self.timePicker.date
			presenter.endDateButton.setTitle(self.timePicker.date.description, for: .normal)
		} else if senderID! == "startTime" {
			presenter.startTime = self.timePicker.date
			presenter.startTimeButton.setTitle(self.timePicker.date.description, for: .normal)
		} else if senderID! == "endTime" {
			presenter.endTime = self.timePicker.date
			presenter.endTimeButton.setTitle(self.timePicker.date.description, for: .normal)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
}
