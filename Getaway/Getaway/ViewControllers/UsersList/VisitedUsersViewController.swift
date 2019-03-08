//
//  VisitedUsersViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 07/03/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class VisitedUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
    var selectedIndex = 0
	var usersVisitedList : [User]!
	
	@IBOutlet weak var usersTableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		updateTableViewCells()
    }
	
	func updateTableViewCells() {
		self.usersTableView.reloadData()
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usersVisitedList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell = usersTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserProfileTableViewCell
		
		
		
		FirebaseClient().retrieveUserInformationByUID(userID: usersVisitedList[indexPath.row].uid) { (userDict) in
			cell.nameLabel.text = "\(userDict["firstName"]!) \(userDict["lastName"]!)"
			cell.usernameLabel.text = userDict["username"]
			cell.relationLabel.text = self.usersVisitedList[indexPath.row].relation
		}
		
		
		
		return cell
		
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "viewProfiles", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProfiles" {
            let viewController = segue.destination as! UserProfileViewController
            // Setup new view controller
            
            let username = usersVisitedList[selectedIndex]
            print(usersVisitedList)
            viewController.username = username.name
            
        }
    }

}
