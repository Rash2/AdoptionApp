//
//  Animal.swift
//  AdoptionApp
//
//  Created by user169231 on 5/9/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import Foundation

class Animal {
    var photoURL: String
    var age: Int
    var species: String
    var breed: String
    var description: String
    var name: String
    var ownerAddress: String
    var ownerId: String
    
    init(photoURL: String, age: Int, species: String, breed: String, description: String, name: String, ownerAddress: String, ownerId: String) {
        self.photoURL = photoURL
        self.age = age
        self.species = species
        self.breed = breed
        self.description = description
        self.name = name
        self.ownerAddress = ownerAddress
        self.ownerId = ownerId
    }
}
