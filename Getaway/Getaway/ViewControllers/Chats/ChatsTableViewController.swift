//
//  AllChatsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/28/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class ChatsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    var selectedIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.friendNameLabel?.text = list[indexPath.row]
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        self.title = "Chats"
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
        })
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
