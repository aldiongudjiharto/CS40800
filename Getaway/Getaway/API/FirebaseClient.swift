//
//  FirebaseClient.swift
//  Getaway
//
//  Created by Avinash Singh on 13/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import Foundation
import Firebase
import MapKit


class FirebaseClient {
	
	var userRef: DatabaseReference!
	
	
	
	func addUser(firstName: String, lastName: String, username: String){
		
		let user = Auth.auth().currentUser
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			userRef = Database.database().reference()

			self.userRef.child("users").child(user.uid).setValue(["email": user.email, "username": username, "firstName": firstName, "lastName": lastName])
			// ...
		}
	}
	
	func retrieveUserInformation(completion: @escaping ([String: String]) -> ()) {
		let user = Auth.auth().currentUser
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			userRef = Database.database().reference().child("users").child(user.uid)
			
			userRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				let userDict = snapshot.value as! [String: String]
				print(userDict)
				completion(userDict)
			})
			
		}
		else{
			completion(["" : ""])
		}
	}
	
	func checkIfUserNameIsUnique(username: String, completion: @escaping (Bool) -> ()){
		
		print(username)
		let usersRef = Database.database().reference().child("users")
		var flag = true
		usersRef.observeSingleEvent(of: .value, with: { snapshot in
			print(snapshot.key)
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				var userInfoDict = snap.value as! [String: String]
				var userNameVal = userInfoDict["username"]!
				if userNameVal == username {
					flag = false
					completion(false)
				}
			}
			
			if flag == true {
				completion(true)
			}

		})
	}
	
	func editUserName(username: String, completion: @escaping (Bool) -> ()) {
		
		let user = Auth.auth().currentUser
		if let user = user {
            self.userRef = Database.database().reference()
			self.userRef.child("users/\(user.uid)/username").setValue(username)
			completion(true)
		} else{
			completion(false)
		}
        
	}
	
	
	
	func addVisitedPlace(placeName: String, coordinate: CLLocationCoordinate2D){
		
		let user = Auth.auth().currentUser
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			userRef = Database.database().reference().child("visited")
			//			let visitedRef = userRef.child(user.uid).childByAutoId()
			//			var placeCoordinatedict:NSDictionary = [placeName : ["lat" : coordinate.latitude, "long" :coordinate.longitude]]
			let visitedRef = userRef.child(user.uid).child(placeName)
			var placeCoordinatedict:NSDictionary = ["lat" : coordinate.latitude, "long" :coordinate.longitude]
			visitedRef.setValue(placeCoordinatedict)
			// ...
			
			
		}
	}
	

	
	
	func retrieveCurrentUsersVisitedPlaces(){
		let user = Auth.auth().currentUser
		var visitedPlacesDict = [String: CLLocationCoordinate2D]()
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			
			let visitedRef = Database.database().reference().child("visited").child(user.uid)
			
			visitedRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				for child in snapshot.children {
					let snap = child as! DataSnapshot
					let placeDict = snap.value as! [String: Any]
					let lat = placeDict["lat"] as! CLLocationDegrees
					let long = placeDict["long"] as! CLLocationDegrees
					var placeName = snap.key
					print(snap.key)
					print(lat, long)
					visitedPlacesDict[placeName] = CLLocationCoordinate2DMake(lat, long)
				}
				print(visitedPlacesDict)
			})
			
			
			// ...
		}
	}
	
	
	
	
	
	func getUserDetails(success: @escaping (User) ->(), failure: @escaping (Error)->()){
		
		//        userRef.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
		//            if let userInfo = snapshot.value as? [String: Any]{
		//                success(User(userInfo: userInfo))
		//            }
		//        })
		
	}
	
	
	
}
