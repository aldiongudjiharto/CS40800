//
//  FirebaseClient.swift
//  Getaway
//
//  Created by Avinash Singh on 13/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import Foundation
import Firebase


class FirebaseClient {
    
    var userRef: DatabaseReference!
    
    
    func checkIfUserIsloggedIn() {
        if Auth.auth().currentUser != nil {
            
            userRef = Database.database().reference().child("users")
            print("User logged in!")
            
        }
        else {
            print("Error, User not logged in")
        }
    }
    
    func addUser(){
        
    }
    
    
    
    func getUserDetails(user: String, success: @escaping (User) ->(), failure: @escaping (Error)->()){
        
        userRef.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfo = snapshot.value as? [String: Any]{
                success(User(userInfo: userInfo))
            }
        })
        
    }
    
    
    
}
