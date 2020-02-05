//
//  TabSelectController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 6/2/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit
import SideMenuSwift

class TabSelectController: UITabBarController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	
	@IBAction func revealSideMenu(_ sender: UIBarButtonItem) {
		self.sideMenuController?.revealMenu(animated: true, completion: { stateVale in
			print("SideMenu: reveal from Rent/Return")
		})
	}
	
}
