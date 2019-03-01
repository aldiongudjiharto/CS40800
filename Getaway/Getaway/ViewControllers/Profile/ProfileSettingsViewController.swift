//
//  ProfileSettingsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/15/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingsViewController: UIViewController {


    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var newUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	@IBAction func changeUsernameFunc(_ sender: Any) {
		if newUsername.text == "" {
			displayAlert(message: "Please enter new username.")
		}
		else {
			
			FirebaseClient().checkIfUserNameIsUnique(username: newUsername.text!) { (userNameUnique) in
				if userNameUnique == true {
					FirebaseClient().editUserName(username: self.newUsername.text!) { (userNameChanged) in
						if userNameChanged {
							self.displayAlert(message: "Username changed successfully!")
						}
						else {
							self.displayAlert(message: "Username could not be changed. Please try again!")
						}
					}
				}
				else {
					self.displayAlert(message: "Username already exists. Please select a new one!")
				}
			}
			
		}
	}
	
	func displayAlert(message:String? = "Please check your credentials"){
		let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
    @IBAction func returnToTabViewController(_ sender: Any) {
        
        self.dismiss(animated:true) {
            let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
            TabViewController.selectedIndex = 3
            UIApplication.shared.keyWindow?.rootViewController = TabViewController
        }
    }

    
    @IBAction func logUserOut(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
        self.present(viewController, animated: false, completion: nil)
        
    }
    
}
