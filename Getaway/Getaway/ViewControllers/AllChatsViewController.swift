//
//  AllChatsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/28/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class AllChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
