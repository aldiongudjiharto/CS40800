//
//  FriendsAddViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/1/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class FriendsAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //Set it to usernames of current -non-friends
    

    @IBOutlet weak var tableView: UITableView!
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! AddFriendsCell
        
        cell.friendUsername?.text = list[indexPath.row]
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Do any additional setup after loading the view.
        
        FirebaseClient().getAllUsers(completion: {(friendsDict) in
            self.friendsDict1 = friendsDict
            self.list = Array(self.friendsDict1.keys)
            print(self.list)
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        })
        
        
    }
    

    @IBAction func addMyFriends(_ sender: Any) {
        //Add friends on database
        self.view.removeFromSuperview()
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
}
