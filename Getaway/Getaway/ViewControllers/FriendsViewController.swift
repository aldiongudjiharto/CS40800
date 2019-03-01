//
//  FriendsViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/15/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
	let list = ["Aldio", "Dhriti", "Avi", "Daniel", "Stef"]
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//let cell = UITableViewCell(style: UITableViewCell.CellStyle, reuseIdentifier: "cell")
		return UITableViewCell 
	}
	
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
		super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		
    }
	
	
}
