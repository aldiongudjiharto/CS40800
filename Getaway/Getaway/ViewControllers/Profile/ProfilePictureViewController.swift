//
//  ProfilePictureViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/6/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class ProfilePictureViewController: UIViewController {

    
    @IBOutlet weak var myPicture: UIImageView?
    var picFromPreviousVC: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myPicture?.image = picFromPreviousVC
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myPicture?.image = picFromPreviousVC
    }
    
    
    @IBAction func goBacktoParent(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    

}
