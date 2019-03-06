//
//  FriendsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/15/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    @IBOutlet weak var tableView: UITableView!
    
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        
        cell.friendNameLabel?.text = list[indexPath.row]
        
		return cell
	}
	
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
		super.viewDidLoad()
		
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    func fetchData(){
        FirebaseClient().getAllFriends(completion: {(friendsDict) in
            self.friendsDict1 = friendsDict
            self.list = Array(self.friendsDict1.values)
            print("-------")
            print(self.list)
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        fetchData()
    }
    
    @IBAction func addNewFriends(_ sender: Any) {
        let addFriendsPopUp:UIViewController = UIStoryboard(name: "MapView", bundle: nil).instantiateViewController(withIdentifier:"friendsPopUpID") as! FriendsAddViewController
        self.addChild(addFriendsPopUp)
        addFriendsPopUp.view.frame = self.view.frame
        self.view.addSubview(addFriendsPopUp.view)
        addFriendsPopUp.didMove(toParent: self)
        fetchData()

    }
	
}
