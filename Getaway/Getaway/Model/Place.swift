//
//  Place.swift
//  Getaway
//
//  Created by Avinash Singh on 06/03/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import Foundation


class Place {
	
	var placeName: String
	var userID: String
	var userName: String
	var coordinates: CLLocationCoordinate2D
	//    var photo: String!
	//    var imageUrl: String
	
	init(placeName: String, coordinates: CLLocationCoordinate2D,   userID: String, userName: String ) {
		self.placeName = placeName
		self.coordinates = coordinates
		self.userID = userID
		self.userName = userName
	}
}
