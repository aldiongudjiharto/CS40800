//
//  SignInViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 08/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var signInWithGmail: UIButton!
    
    @IBOutlet weak var signInWithFacebook: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate=self
        firstName.isHidden = true
        lastName.isHidden = true
        username.isHidden = true
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("\n\n\n\n\nConnected")
            } else {
                print("\n\n\n\n\n\nNot connected")
            }
        })
    }
    
    @IBAction func signInSelectorClicked(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
            firstName.isHidden = true
            lastName.isHidden = true
            username.isHidden = true
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
            firstName.isHidden = false
            lastName.isHidden = false
            username.isHidden = false
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            if isSignIn {
                // Sign in user with firebase
                if checkIfSignInFieldsAreFilled() == true {
                    Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                        if let u = user {
                            //user is found
                        self.performSegue(withIdentifier: "goHome", sender: self)
                            
                        } else {
                            let castedError = error! as NSError
                            let firebaseError = AuthErrorCode(rawValue: castedError.code)!
                            self.displayAlert(message: error?.localizedDescription)
                            print(error?.localizedDescription)
                        }
                    }
                } else {
                    // Empty fields
                    //show alert for UIField if not entered
                    displayAlert(message: "Please make sure all the fields are filled")
                }
                
            } else {
                //Register user with firebase
				if checkIfRegisterFieldsAreFilled() == true {
					FirebaseClient().checkIfUserNameIsUnique(username: username.text!) { (userNameUnique) in
						if userNameUnique == true {
							Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
								if let u = user {
									
									FirebaseClient().addUser(firstName: self.firstName.text!, lastName: self.lastName.text!, username: self.username.text!)
									self.performSegue(withIdentifier: "goHome", sender: self)
									
								} else {
									self.displayAlert(message: error?.localizedDescription)
                                    print("E r r o  o o o  o r .")
								}
							})
						}
						else {
							self.displayAlert(message: "Username is already taken. Please select a new one")
						}
					}
					

					
				}
				else{
					
					//show alert for UIField if not entered
                    displayAlert(message: "Please make sure all the fields are filled")
				}
                
            }
        }
    }
	
	func checkIfRegisterFieldsAreFilled() -> (Bool) {
        if firstName.text == "" || lastName.text == "" || username.text == "" || emailTextField.text == "" || passwordTextField.text == ""{
            return false
        }
		return true
	}
    
    func checkIfSignInFieldsAreFilled() -> (Bool) {
        if emailTextField.text == "" || passwordTextField.text == ""{
            return false
        }
        return true
    }
    
    func checkIfEmailFieldIsFilled() -> (Bool) {
        if emailTextField.text == "" {
            return false
        }
        return true
    }
    
    func displayAlert(message:String? = "Please check your credentials"){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK!", style: UIAlertAction.Style.default, handler: nil))
        
       // self.present(alert, animated: true, completion: nil)  [BUG]
    }
    
    @IBAction func signInWithFacebookClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebase()
				
            case .failed(let err):
                print(err)
                case .cancelled:
                print("cancelled")
            }
        }
    }
    
    
    @IBAction func signInWithGmailClicked(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    
    fileprivate func signIntoFirebase() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if let err = err {
                print(err)
                return
            }
			FirebaseClient().checkIfUserAlreadyExists(completion: { (userExists) in
				if !userExists {
					
					let fullNameArr = user!.displayName!.components(separatedBy: " ")
					
					
					FirebaseClient().addUser(firstName: fullNameArr[0], lastName: fullNameArr[1], username: "defaultUsername")
					
					self.performSegue(withIdentifier:"selectUserNameSegue", sender: self)
					

				}
				else {
					self.performSegue(withIdentifier: "goHome", sender: self)
				}
				
				print ("Successfully logged into Facebook")
				
			})
        }
    }
    
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        let title = "Forgot Password?"
        let message = "Insert your email address below to reset password"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Email"
            self.emailTextField = nameTextField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
//            if self.checkIfEmailFieldIsFilled() == true {
//                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
//                print("error")
//                })
//            } else {
//                self.displayAlert(message: "Please make sure email field is filled")
//            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        self.present(alertController, animated: true, completion: nil)  
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
