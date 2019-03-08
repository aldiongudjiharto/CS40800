//
//  AllChatsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/28/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class ChatsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    var strangerList = [""]
    var selectedIndex = 0
    var myUserName = ""
    let user = Auth.auth().currentUser
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        if (strangerList.contains(list[indexPath.row])){
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        } else {
            cell.backgroundColor = UIColor.white
        }
        cell.friendNameLabel?.text = list[indexPath.row]
        
        return cell
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.strangerList.removeAll()
        self.tabBarController?.tabBar.isHidden = false
        //self.title = "Chats"
        self.navigationItem.title = "Chats";
        fetchData()

        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        FirebaseClient().getAllFriends(completion: {(friendsDict) in
            self.friendsDict1 = friendsDict
            self.list = Array(self.friendsDict1.values)
            
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.fetchMyUserName()
        })
    }
    
    
    func fetchMyUserName(){
        var userDictionary:[String: String] = ["":""]
        FirebaseClient().retrieveUserInformationByUID(userID: user!.uid, completion: { (userDict) in
            userDictionary = userDict
            self.myUserName = userDictionary["username"]!
            
            self.addOtherChats()
        })
    }
    
    func addOtherChats(){
    
        if let user = user {
            let usersRef = Database.database().reference().child("Chats").child(self.myUserName)
            usersRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    if !self.list.contains(snap.key) {
                        self.list.append(snap.key)
                        self.strangerList.append(snap.key)
                        print("....\(snap.key)")
                    }
                }
                
                self.tableView.reloadData()
                self.tableView.delegate = self
                self.tableView.dataSource = self
            })
        }
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        self.strangerList.removeAll()
        //self.title = "Chats"
        self.navigationItem.title = "Chats";
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        self.strangerList.removeAll()
        //self.title = "Chats"
        self.navigationItem.title = "Chats";
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "friendChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "friendChat"
        {
            let viewController = segue.destination as! MyChatViewController
            let username = list[selectedIndex]
            viewController.friendUsername = username
        }
    }

}
