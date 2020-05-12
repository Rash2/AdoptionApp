//
//  UserProfileScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/12/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class UserProfileScreenController: UIViewController {
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNamesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    func setupUserProfile() {
        var currentUser: User?
        guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("users").child(currentUserUID)
        
        userRef.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any],
                let photoURL = dict["photoURL"] as? String,
                let firstname = dict["firstname"] as? String,
                let lastname = dict["lastname"] as? String,
                let city = dict["city"] as? String,
                let street = dict["street"] as? String {
                let user = User(uid: currentUserUID, photoURL: photoURL, firstname: firstname, lastname: lastname, city: city, street: street)
                
                currentUser = user
            }
        }
        
        firstNameLabel.text = currentUser?.firstname
        lastNamesLabel.text = currentUser?.lastname
        cityLabel.text = currentUser?.city
        streetLabel.text = currentUser?.street
        
    }
    

}
