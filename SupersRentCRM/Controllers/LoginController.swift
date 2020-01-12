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
		hideKeyboardWhenTappedAround()
		
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
						
						let userData: [String : Any] = ["isLogin": true, "tokenAccess": tokenAccess, "username": json["username"].stringValue, "userData": json.dictionaryObject!]
						self.updateUserData(userData: userData)
						
						print("Login: saving Data")
						self.loadUserData()
						self.performSegue(withIdentifier: "loginToDashboard", sender: self)
					} else {
						print("Login: Failed")
					}
					
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	func loadUserData() {
		let userData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		print("Loaded Data: \(userData!)")
	}
	
	func updateUserData(userData: [String : Any] ) {
		print("Update: Updating data")
		do {
			try Locksmith.updateData(data: userData, forUserAccount: "admin")
		} catch {
			print(error)
		}
	}
	
	func appInitializer() {
		if Locksmith.loadDataForUserAccount(userAccount: "admin") == nil {
			print("App Initializer: nil ....!")
			do {
				try Locksmith.saveData(data: ["isLogin": false, "tokenAccess": "", "username": "", "userData": ""], forUserAccount: "admin")
			} catch {
				print(error)
			}
		} else {
			print("App Initializer: Have data")
			
			self.loadUserData()
		}
	}
}

extension LoginController: UITextFieldDelegate {
	
}
