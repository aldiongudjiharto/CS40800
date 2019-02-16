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
			print("coming here")
			print(userDict1)
		})
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
