//
//  FriendProfileViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/7/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numFriendsLabel: UILabel!
    @IBOutlet weak var numPinsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var username = ""
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "@\(username)"
        // Do any additional setup after loading the view.
        fetchUserUID()
        
    }
    
    func fetchUserUID() {
        print(username)
        FirebaseClient().getUniqueIdFromUsername(username: username) { (UserUID) in
            self.userUID = UserUID
            print("THE USER UID IS\n")
            print(self.userUID)
            print("THE USER UID IS\n")
            self.fetchUserData()
        }
    }
    
    
    func fetchUserData() {
        var userDictionary:[String: String] = ["":""]
        FirebaseClient().retrieveUserInformationByUID(userID: userUID, completion: { (userDict) in
            userDictionary = userDict
            let fullName = "\(userDictionary["firstName"]!)" + " " +
            "\(userDictionary["lastName"]!)"
            self.nameLabel.text = fullName
            self.usernameLabel.text = userDictionary["username"]!
            
            
            let bioText = userDictionary["userBio"]!.trimmingCharacters(in: .whitespaces)
            if  bioText != nil && bioText != "" {
                self.bioLabel.text = userDictionary["userBio"]!
            }
            else {
                self.bioLabel.text = "*Enter your bio here*"
            }
            

        })
        
    }
    
    func updateUserFriendsPic() {
        
        
    }
    
    func updateUserProfilePic() {
        
        
    }
}
