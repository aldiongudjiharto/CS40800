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
    var email: String!
    //    var photo: String!
//    var imageUrl: String
    
    init(userInfo: [String: Any]) {
        uid = (userInfo["uid"] as! String)
        name = (userInfo["name"] as! String)
        email = (userInfo["email"] as! String)
        //        photo = userInfo["photo"] as! String
//        imageUrl = userInfo["profile_image_url_https"] as! String
    }
}
