//
//  ProfileSettingsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/15/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

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
}
