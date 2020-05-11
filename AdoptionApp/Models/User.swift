//
//  User.swift
//  AdoptionApp
//
//  Created by user169231 on 5/11/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var photoURL: String
    var firstname: String
    var lastname: String
    var city: String
    var street: String
    
    
    init(uid: String, photoURL: String, firstname: String, lastname: String, city: String, street: String) {
        self.uid = uid
        self.photoURL = photoURL
        self.firstname = firstname
        self.lastname = lastname
        self.city = city
        self.street = street
    }
}
