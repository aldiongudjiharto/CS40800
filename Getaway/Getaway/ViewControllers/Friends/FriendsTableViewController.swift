//
//  FriendsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/15/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    var filteredArrayName = [String]()
    var showSearchResults = false
    let searchBar = UISearchBar()
    var selectedIndex = 0
    @IBOutlet weak var tableView: UITableView!
    
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (showSearchResults) {
            return filteredArrayName.count
        }
        else {
            return list.count
        }
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        if (showSearchResults){
            cell.friendNameLabel?.text = filteredArrayName[indexPath.row]
        } else {
            cell.friendNameLabel?.text = list[indexPath.row]
        }
		return cell
	}
	
    
    override func viewDidLoad() {
		super.viewDidLoad()
		
        // Do any additional setup after loading the view.
        fetchData()
        createSearchBar()
    }
    
    func createSearchBar() {
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search a friend...."
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let mySearch = searchBar.text!
        filteredArrayName = list.filter({( name: String) -> Bool in
            return name.lowercased().range(of:searchText.lowercased()) != nil
        })
        
        if mySearch == "" {
            showSearchResults = false
            self.tableView.reloadData()
        } else {
            showSearchResults = true
            self.tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "viewProfile", sender: self)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProfile" {
            let viewController = segue.destination as! FriendProfileViewController
            // Setup new view controller
            if (showSearchResults){
                let username = filteredArrayName[selectedIndex]
                viewController.username = username
            } else {
                let username = list[selectedIndex]
                viewController.username = username
                
            }
        }
    }
    
}
