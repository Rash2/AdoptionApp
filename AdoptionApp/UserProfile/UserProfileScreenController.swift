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
        setupUserProfile()
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let initialViewController = storyboard?.instantiateViewController(identifier: "InitialNavController") as? UINavigationController
        
        
        initialViewController?.modalPresentationStyle = .fullScreen
        initialViewController?.modalTransitionStyle = .crossDissolve
        present(initialViewController!, animated: false, completion: nil)
    }
    
    func setupUserProfile() {
        
        guard let currentUser = UserService.currentUser else {return}
        
        firstNameLabel.text = currentUser.firstname
        lastNamesLabel.text = currentUser.lastname
        cityLabel.text = currentUser.city
        streetLabel.text = currentUser.street
        ImageService.getImage(withURL: currentUser.photoURL) { (image) in
            self.userProfilePictureImageView.image = image
        }
        
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.size.width / 2
        userProfilePictureImageView.clipsToBounds = true
        
    }
    

}
