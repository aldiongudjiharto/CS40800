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
    
    let userRef
    
    func checkIfUserIsloggedIn() {
        
        if Auth.auth().currentUser != nil {
            print("User logged in!")
            let userRef = Database.database().reference().child("users")
        }
        else {
            print("Error, User not logged in")
        }
    }
    
    
    func getUserDetails(){
        
        func getUser(user: String, success: @escaping (User) ->(), failure: @escaping (Error)->()) {
            
            userRef.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userInfo = snapshot.value as? [String: Any]{
                    success(User(userInfo: userInfo))
                }
            })
        }
        
    }
    
    
    
}
