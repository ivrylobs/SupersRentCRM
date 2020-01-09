//
//  LoginController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class LoginController: UIViewController {
	
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.appInitializer()
		
	}
	
	
	@IBAction func loginButton(_ sender: UIButton) {
		self.loginByUsername()
	}
	
	func loginByUsername() {
		
		let username = self.usernameTextField.text!
		let password = self.passwordTextField.text!
		
		let url = "https://api.supersrent.com/app-admin/api/auth/signin/"
		let para: [String: Any] = ["username": username, "password": password]
		Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default).responseJSON { response in
			DispatchQueue.main.async {
				switch response.result {
					
					case .success(let data):
						
						let json = JSON(data)
						
						if let tokenKey = json["accessToken"].string {
							
							print(tokenKey)
							
							let tokenAccess = "\(json["tokenType"].stringValue) \(tokenKey)"
							
							let userData = ["isLogin": true, "tokenAccess": tokenAccess, "username": json["username"].stringValue, "userData": json.arrayValue] as [String : Any]
							self.updateUserData(userData: userData)
							
							print("saved Data")
							self.loadUserData()
							self.performSegue(withIdentifier: "loginToDashboard", sender: self)
						} else {
							print("Login Failed")
						}
					
					case .failure(let error):
						print(error)
				}
			}
		}
	}
	
	func loadUserData() {
		let userData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		print(userData!)
	}

	func updateUserData(userData: [String : Any] ) {
		print("Do update data")
		do {
			try Locksmith.updateData(data: userData, forUserAccount: "admin")
		} catch {
			print(error)
		}
	}
	
	func appInitializer() {
		if Locksmith.loadDataForUserAccount(userAccount: "admin") == nil {
			print("nil ....")
			do {
				try Locksmith.saveData(data: ["isLogin": false, "tokenAccess": "", "username": "", "userData": ""], forUserAccount: "admin")
			} catch {
				print(error)
			}
		} else {
			print("have data")
			
			self.loadUserData()
		}
	}
}

extension LoginController: UITextFieldDelegate {
	
}
