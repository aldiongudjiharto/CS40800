//
//  FriendProfileViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/7/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numFriendsLabel: UILabel!
    @IBOutlet weak var numPinsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    var userRef = Database.database().reference()
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
            self.usernameLabel.text = "@\(userDictionary["username"]!)"
            
            
            let bioText = userDictionary["userBio"]!.trimmingCharacters(in: .whitespaces)
            if  bioText != nil && bioText != "" {
                self.bioLabel.text = userDictionary["userBio"]!
            }
            else {
                self.bioLabel.text = ""
            }
            
            self.updateUserPins()
        })
        
    }
    
    func updateUserPins() {
        var placeDictionary = [Place]()
        
        FirebaseClient().getVisitedPlacesForUser(userId: userUID, username: username) { (places) in
            placeDictionary = places
            var numberOfPlaces = placeDictionary.count
            self.numPinsLabel.text = "Has dropped \(numberOfPlaces) pins"
            self.updateUserFriends()
        }
    }
    
    func updateUserFriends() {
        var friendDictionary:[String: String] = ["":""]
        FirebaseClient().getAllFriendsByUID(uid: userUID) { (friendDict) in
            friendDictionary = friendDict
            var numberOfFriends = friendDictionary.count
            self.numFriendsLabel.text = "Has \(numberOfFriends) friends"
            
            self.updateUserProfilePic()
        }
    }
    
    func updateUserProfilePic() {
         var profViewPicRef = Storage.storage().reference().child(userUID).child("profile_pic")
        
        self.userRef.child("profile_pics").child(userUID).observeSingleEvent(of: .value) {
            (snapshot: DataSnapshot) in
            if snapshot.exists(){
                print(snapshot)
                //let databaseProfilePic = self.userRef.child("profile_pics").value(forKey: (self.user!.uid)) as? String!
                if let snapDict = snapshot.value as? String {
                    
                    //here you can get data as string , int or anyway you want
                    let databaseProfilePic = snapDict
                    let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL)
                    print("\n\n\(databaseProfilePic)\n\n")
                    self.setProfilePicture(imageView: self.profileImage,imageToSet:UIImage(data: data! as Data)!)
                    
                }
            } else {
                //this guy doesnt have a profile pic
                print("NO DP.... HMM ...")
            }
            
        }
    }
    
    func setProfilePicture(imageView:UIImageView, imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
}
