//
//  ProfileViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/8/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var myBio: UITextView!
    @IBOutlet weak var bioButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		var userDict1:[String: String] = ["":""]
		FirebaseClient().retrieveUserInformation(completion: {(userDict) in
			userDict1 = userDict
			print(userDict1)
            
            self.setUserDetails(userDictionary: userDict1)
		})
        
    }
    
    func setUserDetails(userDictionary: [String: String]){
        let fullName = "\(userDictionary["firstName"]!)" + " " +
        "\(userDictionary["lastName"]!)"
        print(fullName)
        myName.text = fullName
        myUserName.text = userDictionary["username"]!
        
    }

}
