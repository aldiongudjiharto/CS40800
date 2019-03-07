//
//  FriendsAddViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/1/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class FriendsAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    //Set it to usernames of current -non-friends
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    var filteredArrayName = [String]()
    var showSearchResults = false
    var selectednames = [String]()
    var myUsername = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (showSearchResults) {
            return filteredArrayName.count
        }
        else {
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! AddFriendsCell
        if (showSearchResults){
            cell.friendUsername?.text = filteredArrayName[indexPath.row]
        } else {
            cell.friendUsername?.text = list[indexPath.row]
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectednames.removeAll()
        searchBar.delegate = self
        
        tableView.allowsMultipleSelection = true
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = true;
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        
        var userDict1:[String: String] = ["":""]
        FirebaseClient().retrieveUserInformation(completion: {(userDict) in
            userDict1 = userDict
            self.myUsername = userDict1["username"]!
            print(self.myUsername)
        })
        
        // Do any additional setup after loading the view.
        FirebaseClient().getAllUsers(completion: {(friendsDict) in
            self.friendsDict1 = friendsDict
            self.list = Array(self.friendsDict1.keys)
            self.list.remove(at: self.list.firstIndex(of: self.myUsername)!)
            print(self.list)
            self.tableView.reloadData()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        })
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        if (showSearchResults) {
            if (!selectednames.contains(filteredArrayName[indexPath.row])) {
                selectednames.append(filteredArrayName[indexPath.row])
            }
            else {
                cell.accessoryType = .none
                let a = selectednames.index(of: filteredArrayName[indexPath.row])
                selectednames.remove(at: a!)
            }
        }
        else {
            if (!selectednames.contains(list[indexPath.row])) {
                selectednames.append(list[indexPath.row])
            }
            else {
                cell.accessoryType = .none
                let a = selectednames.index(of: list[indexPath.row])
                selectednames.remove(at: a!)
            }
        }
        // cell.accessoryView.hidden = false // if using a custom image
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
//        if (showSearchResults) {
//            let a = selectednames.index(of: filteredArrayName[indexPath.row])
//            selectednames.remove(at: a!)
//        }
//        else {
            let a = selectednames.index(of: list[indexPath.row])
            selectednames.remove(at: a!)
//        }
        // cell.accessoryView.hidden = true  // if using a custom image
    }

    @IBAction func addMyFriends(_ sender: Any) {
        //Add friends on database
        print(selectednames)
        
        if (selectednames.count == 0){
            let alert = UIAlertController(title: "Error", message: "Please select at least one user to be added to your friend list :)", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
                print("ERROR")
            }
        } else {
            for namez in self.selectednames {
                
                FirebaseClient().addFriend(friendUsername: namez) { (bool) in
                    if (bool){
                        print("Yay! friend added")
                    } else {
                        print("Hmmm something seems wrong with ur frnd")
                    }
                }
            }
            self.view.removeFromSuperview()
        }
        
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    
}
