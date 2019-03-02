//
//  SelectUsernameViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 01/03/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class SelectUsernameViewController: UIViewController {

	@IBOutlet weak var userNameTextField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func selectUsernameButtonClicked(_ sender: Any) {
		if userNameTextField.text != "" {
			FirebaseClient().checkIfUserNameIsUnique(username: userNameTextField.text!) { (userNameUnique) in
				if userNameUnique == true {
					var currentUser = Auth.auth().currentUser
					FirebaseClient().editUserName(username: self.userNameTextField.text!, completion: { (userNameChanged) in
						if userNameChanged {
							
							//perform segue to mapview
							self.performSegue(withIdentifier: "goToHomePageSegue", sender: self)
						}
						else{
							//show popup
							self.displayAlert(message: "An error occured. Please try again.")
						}
					})
					
				}
				else{
					self.displayAlert(message: "Username is already taken. Please select a new one")
				}
			}
		}
	}
	
	func displayAlert(message:String? = "Please check your credentials"){
		let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
