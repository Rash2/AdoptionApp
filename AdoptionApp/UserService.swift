//
//  UserService.swift
//  AdoptionApp
//
//  Created by user169231 on 5/11/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUser: User?
    
    static func observeUserProfile(_ uid: String, completion: @escaping ((_ userProfile: User?) -> ())) {
        let userRef = Database.database().reference().child("users/\(uid)")
        userRef.observe(.value, with: { snapshot in
            var user: User?
            
            if let dict = snapshot.value as? [String: Any],
                let photoURL = dict["photoURL"] as? String,
                let firstname = dict["firstname"] as? String,
                let lastname = dict["lastname"] as? String,
                let city = dict["city"] as? String,
                let street = dict["street"] as? String {
                    
                user = User(uid: snapshot.key, photoURL: photoURL, firstname: firstname, lastname: lastname, city: city, street: street)
            }
            completion(user)
        })
    }
}
