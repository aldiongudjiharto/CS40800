//
//  ProfileViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/8/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storageRef = Storage.storage().reference()
    var profViewPicRef = Storage.storage().reference()
    let user = Auth.auth().currentUser
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var myBio: UITextView!
    var imagePicker = UIImagePickerController()
    var userRef = Database.database().reference()
    var hasPicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.myBio.endEditing(true)
        // Do any additional setup after loading the view.
		var userDict1:[String: String] = ["":""]
		FirebaseClient().retrieveUserInformation(completion: {(userDict) in
			userDict1 = userDict
            self.setUserDetails(userDictionary: userDict1)
		})
        
        profViewPicRef = Storage.storage().reference().child(user!.uid).child("profile_pic")
        
        self.userRef.child("profile_pics").child(user!.uid).observeSingleEvent(of: .value) {
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
                    self.hasPicture = true
                }
            } else {
                //this guy doesnt have a profile pic
                print("NO DP.... HMM ...")
            }
            
        }
    }
	
	
	
	
	
	func updateUserInformation() {
		FirebaseClient().retrieveUserInformation(completion: {(userDict) in
			if userDict != nil {
				self.setUserDetails(userDictionary: userDict)
			}
			
		})
	}
	
        
    
    func setUserDetails(userDictionary: [String: String]){
        let fullName = "\(userDictionary["firstName"]!)" + " " +
        "\(userDictionary["lastName"]!)"
        print(fullName)
        myName.text = fullName
        myUserName.text = "@\(userDictionary["username"]!)"
		
		
		var bioText = userDictionary["userBio"]!.trimmingCharacters(in: .whitespaces)
		if  bioText != nil && bioText != "" {
			myBio.text = userDictionary["userBio"]!
		}
		else {
			myBio.text = "*Enter your bio here*"
		}
		
		//updateBioPlaceHolder()  [BUG]
        
    }
    
    
    @IBAction func EditProfPicture(_ sender: Any) {
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Please select one of the following:", preferredStyle: UIAlertController.Style.actionSheet)
        if (hasPicture == false){
            //the guy has no picture currently
            let photoGallery = UIAlertAction(title: "Add Picture", style: UIAlertAction.Style.default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)
                {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
            myActionSheet.addAction(photoGallery)
            myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(myActionSheet, animated: true, completion: nil)
            
        } else {
            //the guy has a picture currently
            let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertAction.Style.default) { (action) in
                let imageView = self.profileImage as UIImageView
                
                let addPicPopUp = UIStoryboard(name: "MapView", bundle: nil).instantiateViewController(withIdentifier:"picPopUpID") as! ProfilePictureViewController
                
                addPicPopUp.picFromPreviousVC = self.profileImage.image
                self.addChild(addPicPopUp)
                addPicPopUp.view.frame = self.view.frame
                
                self.view.addSubview(addPicPopUp.view)
                addPicPopUp.didMove(toParent: self)
                
            }
            
            let photoGallery = UIAlertAction(title: "Add Picture", style: UIAlertAction.Style.default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)
                {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            
            let delete = UIAlertAction(title: "Delete Picture", style: UIAlertAction.Style.default) { (action) in
                //DO STUFF FOR DELETING
                self.userRef.child("profile_pics").child(self.user!.uid).removeValue()
                self.hasPicture = false
                
                // Create a reference to the file to delete
                let desertRef = self.storageRef.child("\(self.user!.uid)/profile_pic")
                
                // Delete the file
                desertRef.delete { error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                    }
                }
                
                self.profileImage.image = UIImage(named: "blank-profile-picture-973460_960_720")
                
                
            }
            myActionSheet.addAction(viewPicture)
            myActionSheet.addAction(photoGallery)
            myActionSheet.addAction(delete)
            myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(myActionSheet, animated: true, completion: nil)
        }
       
        
    }
	
	@IBAction func saveBioButtonClicked(_ sender: Any) {
		self.myBio.endEditing(true)
		
		if myBio.text != "*Enter your bio here*" {
			
			FirebaseClient().UpdateUserBio(userBio: myBio.text!) { (bioUpdated) in
				if bioUpdated == true {
					self.displayAlert(message: "Bio Updated Successfully!")
					
					self.updateUserInformation()
				}
				else{
					self.displayAlert(message: "Error Occured")
				}
			}
		}
		
	}
	
	
	func updateBioPlaceHolder() {
		var bio = myBio.text.trimmingCharacters(in: .whitespaces)
		bio = bio.replacingOccurrences(of: "\n", with: "")
		
		if bio == nil || bio == "" {
			myBio.text = "*Enter your bio here*"
		}
	}
	
	
	func displayAlert(message:String? = "Error Occured"){
		let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
    
    func setProfilePicture(imageView:UIImageView, imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
	
	
	@IBAction func tapGestureRecognizerClicked(_ sender: Any) {
		myBio.endEditing(true)
	}
	
	
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        setProfilePicture(imageView: self.profileImage, imageToSet: image)
        
        
        if let imageData: NSData = self.profileImage.image!.pngData()! as NSData
        {
            let profileImageRef = storageRef.child("\(self.user!.uid)/profile_pic")
            let userRef = Database.database().reference().child("profile_pics").child(user!.uid)
           
            if user != nil {
                var UrlString = "Url_is_here"
                let uploadTask = profileImageRef.putData(imageData as Data, metadata: nil){
                    metadata, error in
                    if (error == nil) {
                        profileImageRef.downloadURL { (URL, error) -> Void in
                            if (error != nil) {
                                // Handle any errors
                                print(error?.localizedDescription)
                            } else {
                                UrlString = (URL?.absoluteString)!
                                print("\n\n\(UrlString)+\n\n\n\n")
                                // you will get the String of Url
                                print("successful upload")
                                userRef.setValue(UrlString)
                                self.hasPicture = true
                            }
                        }
                        
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
