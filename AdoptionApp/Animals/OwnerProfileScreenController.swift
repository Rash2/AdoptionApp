//
//  OwnerProfileScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/22/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class OwnerProfileScreenController: UIViewController {

    @IBOutlet weak var ownerProfilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    
    var ownerUid = ""
    var owner: User? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupOwnerProfile()
    }
    

    func setupOwnerProfile() {
        ownerProfilePictureImageView.layer.cornerRadius = ownerProfilePictureImageView.frame.size.width / 2
        ownerProfilePictureImageView.clipsToBounds = true

        
        let userRef = Database.database().reference().child("users/\(self.ownerUid)")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any],
                let photoURL = dict["photoURL"] as? String,
                let firstname = dict["firstname"] as? String,
                let lastname = dict["lastname"] as? String,
                let city = dict["city"] as? String,
                let street = dict["street"] as? String {
                
                self.owner = User(uid: self.ownerUid, photoURL: photoURL, firstname: firstname, lastname: lastname, city: city, street: street)
                
                self.firstNameLabel.text = firstname
                self.lastNameLabel.text = lastname
                self.cityLabel.text = city
                self.streetLabel.text = street
                
                ImageService.getImage(withURL: URL(string: photoURL)!) { (image) in
                    self.ownerProfilePictureImageView.image = image
                }
            }
        }
    }
    
    @IBAction func messageOwnerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "userProfileToNewMessageSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewMessageScreenController
        vc.receiverUID = ownerUid
    }
    

}
