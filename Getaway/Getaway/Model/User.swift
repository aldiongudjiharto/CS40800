//
//  User.swift
//  Getaway
//
//  Created by Avinash Singh on 13/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import Foundation

class User {
    
    static var current: User?
    var uid: String!
    var name: String!
	var relation: String!
	
	init(uid: String, name: String, relation: String) {
		
		self.uid = uid
		self.name = name
		self.relation = relation

    }
}
