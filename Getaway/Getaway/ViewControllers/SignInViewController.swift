//
//  SignInViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 08/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signInLabel: UILabel!
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
