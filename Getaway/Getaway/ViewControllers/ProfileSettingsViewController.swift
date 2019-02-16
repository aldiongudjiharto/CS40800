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
