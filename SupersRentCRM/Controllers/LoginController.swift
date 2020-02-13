//
//  LoginController.swift
//  SupersRentCRM
//
//  Created by ivrylobs on 10/1/2563 BE.
//  Copyright © 2563 banraomaibab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith
import KeyboardAvoidingView
import PopupDialog
import SideMenuSwift

class LoginController: UIViewController {
	
	//Get the Content View and Menu View from Storyboard.
	let contentView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashBoardViewController")
	let menuView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController")
	
	//Get TextField from LoginView.
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Implement this method for abadon keyboard when not typing.
		hideKeyboardWhenTappedAround()
		
		//Init localStorage
		self.appInitializer()
		
		//Define delegate pattern.
		self.usernameTextField.delegate = self
		self.passwordTextField.delegate = self
		
		//Setup SideMenu.
		SideMenuController.preferences.basic.menuWidth = CGFloat(240)
		SideMenuController.preferences.basic.direction = .left
	}
	
	@IBAction func loginButton(_ sender: UIButton) {
		self.loginByUsername()
	}
	
	func loginByUsername() {
		
		let username = self.usernameTextField.text!
		let password = self.passwordTextField.text!
		
		let url = "https://api.supersrent.com/app-admin/api/auth/signin/"
		let para: [String: Any] = ["username": username, "password": password]
		
		self.pullAPI(url: url, method: .post, parameters: para) { json in
			if let tokenKey = json["accessToken"].string {

				let tokenAccess = "\(json["tokenType"].stringValue) \(tokenKey)"
				
				let userData: [String : Any] = ["isLogin": true, "tokenAccess": tokenAccess, "username": json["username"].stringValue, "userData": json.dictionaryObject!]
				self.updateUserData(userData: userData)
				
				print("Login: saving Data")
				self.loadUserData()
				
				SideMenuController.preferences.basic.defaultCacheKey = "0"
				let sideMenu = SideMenuController(contentViewController: self.contentView, menuViewController: self.menuView)
                sideMenu.modalPresentationStyle = .fullScreen
				sideMenu.restorationIdentifier = "sideMenu"
				self.present(sideMenu, animated: true) {
					print("SideMenu: reveal SideMenu")
				}
			} else {
				print("Login: Failed")
				
				let loginFailAlert = PopupDialog(title: "ผิดพลาด", message: "เข้าสู่ระบบผิดพลาด ชื่อผู้ใช้หรือรหัสผ่านผิด")
				let okAlertFailButton = DefaultButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
				loginFailAlert.addButton(okAlertFailButton)
				self.present(loginFailAlert, animated: true, completion: nil)
			}
		}
	}
	
	func loadUserData() {
		let userData = Locksmith.loadDataForUserAccount(userAccount: "admin")
		print("Loaded Data: \(JSON(userData!))")
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
	
	func pullAPI(url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, header: HTTPHeaders? = nil, handler: @escaping (JSON) -> Void) {
		if parameters != nil && header == nil {
			Alamofire.request(url, method: method, parameters: parameters!, encoding: JSONEncoding.default).responseJSON { response in
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
			Alamofire.request(url, method: method, headers: header).responseJSON { response in
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
			Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
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

extension LoginController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.restorationIdentifier! == "username" {
			textField.endEditing(true)
			self.passwordTextField.becomeFirstResponder()
		} else if textField.restorationIdentifier! == "password" {
			textField.endEditing(true)
			self.loginByUsername()
		}
		return true
	}
}
