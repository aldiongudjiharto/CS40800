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
			
			self.userRef.child("users").child(user.uid).setValue(["email": user.email, "username": username, "firstName": firstName, "lastName": lastName, "userBio": ""])
			
			self.getAllUsers { (allUsersList) in
				print("all users \(allUsersList)")
			}
		}
	}



	func checkIfUserAlreadyExists(completion: @escaping (Bool) -> ()){
		let user = Auth.auth().currentUser
		if let user = user {
			print(user.uid)
			userRef = Database.database().reference()
			
			self.userRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
					// Get user value
					if snapshot.hasChild(user.uid) {
						print("User Already exists")
						completion(true)
					}
					else {
						print("does not exist")
						completion(false)
					}
				})
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
	
	
	
	func retrieveUserInformationByUID(userID: String, completion: @escaping ([String: String]) -> ()) {
		let user = Auth.auth().currentUser
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			userRef = Database.database().reference().child("users").child(userID)
			
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
	
	//Bug - username never saved
	
	func editUserName(username: String, completion: @escaping (Bool) -> ()) {
		
//		let user = Auth.auth().currentUser
//		if let user = user {
//            self.userRef = Database.database().reference()
//			self.userRef.child("users/\(user.uid)/username").setValue(username)
//			completion(true)
//		} else{
//			completion(false)
//		}
		
		completion(false)
		
	}
	
	
	
	func addVisitedPlace(placeName: String, coordinate: CLLocationCoordinate2D){
		
		let user = Auth.auth().currentUser
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			let char: Character = "."
			let sensitiveCount = placeName.characters.filter { $0 == char }.count
			if (sensitiveCount > 0) {
				return
			}
			
			var newPlaceName = placeName.replacingOccurrences(of: ".", with: "")
			
			userRef = Database.database().reference().child("visited")
			//			let visitedRef = userRef.child(user.uid).childByAutoId()
			//			var placeCoordinatedict:NSDictionary = [placeName : ["lat" : coordinate.latitude, "long" :coordinate.longitude]]
			let visitedRef = userRef.child(user.uid).child(newPlaceName)
			var placeCoordinatedict:NSDictionary = ["lat" : coordinate.latitude, "long" :coordinate.longitude]
			visitedRef.setValue(placeCoordinatedict)
			// ...
			
		}
	}
	
	func retrieveCurrentUsersVisitedPlaces(completion: @escaping ([Place]) -> ()){
		let user = Auth.auth().currentUser
//		var visitedPlacesDict = [String: CLLocationCoordinate2D]()
		var visitedPlacesDict = [Place]()
		if let user = user {
			// The user's ID, unique to the Firebase project.
			// Do NOT use this value to authenticate with your backend server,
			// if you have one. Use getTokenWithCompletion:completion: instead.
			
			retrieveUserInformation { (currentUserInfo) in
				
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
						visitedPlacesDict.append(Place(placeName: placeName, coordinates: CLLocationCoordinate2DMake(lat, long), userID: user.uid, userName: currentUserInfo["username"]!))
						//					visitedPlacesDict[placeName] = CLLocationCoordinate2DMake(lat, long)
					}
					print(visitedPlacesDict)
					completion(visitedPlacesDict)
				})

			}

			// ...
		}
	}
	
	
	func retrieveCurrentUsersFriendsVisitedPlaces(completion: @escaping ([Place]) -> ()) {
		var visitedPlacesDict = [Place]()
		var count = 0
		getAllFriends { (friendList) in
			for friend in friendList {
				print(friend)
				
				FirebaseClient().getVisitedPlacesForUser(userId: friend.key, username: friend.value, completion: { (friendVisitedPlaces) in
					count = count + 1
					if friendVisitedPlaces.isEmpty {
						//not sure about this one
						
					}
					else {
						
						visitedPlacesDict.append(contentsOf: friendVisitedPlaces)
//						visitedPlacesDict = visitedPlacesDict.reduce(into: friendVisitedPlaces) { (r, e) in r[e.0] = e.1 }
						
						if friendList.count == count {
							completion(visitedPlacesDict)
						}
					}
				})
				
			}
			print("all friends search completed:")
			//print(visitedPlacesDict)
			
		}
		
		
	}
	
	
	func retrieveAllUsersVisitedPlaces(completion: @escaping ([Place]) -> ()) {

		
		print("coming to all users")
		getAllUsersWithUserId { (userList) in
			
			var visitedPlacesDict = [Place]()
			var count = 0
			
			for user in userList {
				print(user)
				
				self.getVisitedPlacesForUser(userId: user.key, username: user.value, completion: { (userVisitedPlaces) in
					count = count + 1
					if userVisitedPlaces.isEmpty {
						//not sure about this one
						
					}
					else {
//						visitedPlacesDict = visitedPlacesDict.reduce(into: userVisitedPlaces) { (r, e) in r[e.0] = e.1 }
						visitedPlacesDict.append(contentsOf: userVisitedPlaces)
						if userList.count == count {
//							print("all users search completed:")
//							for place in visitedPlacesDict {
//								print(place.placeName)
//							}
							completion(visitedPlacesDict)
						}
					}
				})
				
			}

			//print(visitedPlacesDict)
			
		}
		
		
	}
	
	
	
	func getVisitedPlacesForUser(userId: String, username: String, completion: @escaping ([Place]) -> ()) {
		
		var visitedPlacesDict = [Place]()
		
		let visitedRef = Database.database().reference().child("visited").child(userId)
		
		visitedRef.observeSingleEvent(of: .value, with: { snapshot in
			print(snapshot.key)
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				let placeDict = snap.value as! [String: Any]
				let lat = placeDict["lat"] as! CLLocationDegrees
				let long = placeDict["long"] as! CLLocationDegrees
				var placeName = snap.key
				//print(snap.key)
				//print(lat, long)
				visitedPlacesDict.append(Place(placeName: placeName, coordinates: CLLocationCoordinate2DMake(lat, long), userID: userId, userName: username))
//				visitedPlacesDict[placeName] = CLLocationCoordinate2DMake(lat, long)
			}
			//					print(visitedPlacesDict)
			
			completion(visitedPlacesDict)
		})
	}
	
    func getUniqueIdFromUsername( username: String, completion: @escaping (String) -> ()){
		let user = Auth.auth().currentUser
		
		if let user = user {
			
			let usersRef = Database.database().reference().child("users")
			
			usersRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				for child in snapshot.children {
					
					let snap = child as! DataSnapshot
					
					let userDict = snap.value as! [String: String]
					let userId = snap.key
					
					if userDict["username"] == username {
						completion(userId)
					}
				}
			})
			
			
		}
    }
    
	
    func addFriend(friendUsername: String, completion: @escaping (Bool) -> ()){
        let user = Auth.auth().currentUser
        
        if let user = user {
            getUniqueIdFromUsername(username: friendUsername) { (friendUserId) in
                
                let friendRef = Database.database().reference().child("friends").child(user.uid).child(friendUserId)
                friendRef.setValue(friendUsername)
                completion(true)
                
            }
        }
        
        completion(false)
    }
	
    
    func getAllFriends(completion: @escaping ([String: String]) -> ()){
		let user = Auth.auth().currentUser
		var friendsDict = [String: String]()
		if let user = user {

			let friendsRef = Database.database().reference().child("friends").child(user.uid)

			friendsRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				for child in snapshot.children {
					let snap = child as! DataSnapshot
					let friendUsername = snap.value as! String
					let friendUserId = snap.key
					friendsDict[friendUserId] = friendUsername
				}
				completion(friendsDict)
			})


		}
    }
	
    func getAllFriendsByUID(uid: String, completion: @escaping ([String: String]) -> ()){
        let user = Auth.auth().currentUser
        var friendsDict = [String: String]()
        if let user = user {
            
            let friendsRef = Database.database().reference().child("friends").child(uid)
            
            friendsRef.observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot.key)
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let friendUsername = snap.value as! String
                    let friendUserId = snap.key
                    friendsDict[friendUserId] = friendUsername
                }
                completion(friendsDict)
            })
            
            
        }
    }
	
	
	
	func getAllUsersWithUserId(completion: @escaping ([String: String]) -> ()){
		let user = Auth.auth().currentUser
		var usersDict = [String: String]()
		if let user = user {
			
			let usersRef = Database.database().reference().child("users")
			
			usersRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				for child in snapshot.children {
					
					let snap = child as! DataSnapshot
					
					let userDict = snap.value as! [String: String]
					let userId = snap.key
					
					usersDict[userId] = userDict["username"]!
				}
				completion(usersDict)
			})
			
			
		}
	}
	
	
	func getAllUsers(completion: @escaping ([String: String]) -> ()){
		let user = Auth.auth().currentUser
		var usersDict = [String: String]()
		if let user = user {
			
			let usersRef = Database.database().reference().child("users")
			
			usersRef.observeSingleEvent(of: .value, with: { snapshot in
				print(snapshot.key)
				for child in snapshot.children {
					
					let snap = child as! DataSnapshot
					
					let userDict = snap.value as! [String: String]
					let friendUserId = snap.key
					
					usersDict[userDict["username"]!] = "\(userDict["firstName"]!) \(userDict["lastName"]!)"
				}
				completion(usersDict)
			})
			
			
		}
	}
	
	
	func userAreFriends(friendId: String, completion: @escaping (String) -> ()) {
		let user = Auth.auth().currentUser
		
		
		
		if let user = user {
			
			if user.uid == friendId {
				
				completion("CurrentUser")
			}
			else {
				
				
				let friendsRef = Database.database().reference().child("friends").child(user.uid)
				
				friendsRef.observeSingleEvent(of: .value, with: { (snapshot) in
					
					if snapshot.hasChild(friendId){
						
						print("users are friends")
						completion("Friend")
						
					}
					else {
						
						print("false room doesn't exist")
						completion("GlobalUser")
					}
					
					
				})
				
			}
			
			
			
		}
		
		
	}

	//BUG-user bio never saved
	
	func UpdateUserBio(userBio: String, completion: @escaping (Bool) -> ()) {
		
//		let user = Auth.auth().currentUser
//
//		if let user = user {
//			self.userRef = Database.database().reference()
//			self.userRef.child("users/\(user.uid)/userBio").setValue(userBio)
//			completion(true)
//		}
//		else{
//			completion(false)
//		}
//
		
		completion(true)
	}
	

	
	
}
