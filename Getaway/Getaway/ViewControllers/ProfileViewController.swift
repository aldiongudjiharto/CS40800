//
//  ProfileViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/8/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storageRef = Storage.storage().reference()
    let user = Auth.auth().currentUser
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var myBio: UITextView!
    @IBOutlet weak var bioButton: UIButton!
    var imagePicker = UIImagePickerController()
    var userRef: DatabaseReference!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		var userDict1:[String: String] = ["":""]
		FirebaseClient().retrieveUserInformation(completion: {(userDict) in
			userDict1 = userDict
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
    
    
    @IBAction func EditProfPicture(_ sender: Any) {
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertController.Style.actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertAction.Style.default) { (action) in
            let imageView = sender as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            self.view.addSubview(newImageView)
        }
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertAction.Style.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func setProfilePicture(imageView:UIImageView, imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        setProfilePicture(imageView: self.profileImage, imageToSet: image)
        
        
        if let imageData: NSData = self.profileImage.image!.pngData()! as NSData
        {
            let profileImageRef = storageRef.child("Users/\(self.user!.uid)/profile_pic")
            if let user = user {
                userRef = Database.database().reference().child("users").child(user.uid)
                
                let uploadTask = profileImageRef.putData(imageData as Data, metadata: nil)
                {metadata, error in
                    if (error == nil) {
                        let downloadURL = profileImageRef.downloadURL
                        self.userRef.child("UserDetails").child("profile_pic").setValue(downloadURL)
                        var profpic = downloadURL
                        print("successful upload")
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                    //self.imageLoader.stopAnimating()
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
