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
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func signInSelectorClicked(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            if isSignIn {
                // Sign in user with firebase
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if let u = user {
                        //user is found
                    self.performSegue(withIdentifier: "goHome", sender: self)
                        
                    } else {
                        //error
                        
                    }
                }
                
            } else {
                //Register user with firebase
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
                    if let u = user {
                    self.performSegue(withIdentifier: "goHome", sender: self)
                    } else {
                        
                    }
                })
                
            }
        }
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
            print ("Successfully logged into Facebook")
            self.performSegue(withIdentifier: "goHome", sender: self)
        }
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
