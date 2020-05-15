//
//  AnimalProfileScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/11/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class AnimalProfileScreenController: UIViewController {
    
    var selectedAnimal: Animal!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animalPictureView: UIImageView!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerFullNameLabel: UILabel!
    @IBOutlet weak var ownerAddressLabel: UILabel!
    
    
    @IBOutlet weak var removeFromAdoptionListButton: UIButton!
    @IBOutlet weak var viewOwnerButton: UIButton!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAnimalProfile()
        
    }
    
    
    func setupAnimalProfile() {
        nameLabel.text = selectedAnimal.name
        speciesLabel.text = selectedAnimal.species
        breedLabel.text = selectedAnimal.breed
        ageLabel.text = String(selectedAnimal.age)
        descriptionLabel.text = selectedAnimal.description
        ownerFullNameLabel.text = selectedAnimal.owner.firstname + " " + selectedAnimal.owner.lastname
        ownerAddressLabel.text = selectedAnimal.owner.city + ", " + selectedAnimal.owner.street
        
        ImageService.getImage(withURL: selectedAnimal.photoURL) { (image) in
            self.animalPictureView.image = image
        }
        
        guard let currentUser = UserService.currentUser else {return}
        if currentUser.uid == selectedAnimal.owner.uid {
            viewOwnerButton.isHidden = true
            addToFavouritesButton.isHidden = true
        } else {
            removeFromAdoptionListButton.isHidden = true
//            var addedToFavourites = false
//            let favouritesRef = Database.database().reference().child("favourites")
//            favouritesRef.observeSingleEvent(of: .value) { (snapshot) in
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot,
//                        let dict = childSnapshot.value as? [String: Any],
//                        let addedByUser = dict["addedByUser"] as? String,
//                        let animal = dict["animal"] as? [String: Any],
//                        let animalId = animal["id"] as? String {
//                        if addedByUser == currentUser.uid, self.selectedAnimal.id == animalId {
//                            addedToFavourites = true
//                        }
//                    }
//                }
//                if addedToFavourites == true {
//                    addToFavouritesButton.backgroundColor = 
//                }
//            }
        }
        
        
    }
    
    
    @IBAction func addToFavouritesButtonPressed(_ sender: Any) {
        guard let currentUser = UserService.currentUser else {return}
        
        let favouritesRef = Database.database().reference().child("favourites").childByAutoId()
        let favouriteAnimalObject = [
            "addedByUser": currentUser.uid,
            "animal": [
                "id": selectedAnimal.id,
                "photoURL": selectedAnimal.photoURL.absoluteString,
                "age": selectedAnimal.age,
                "name": selectedAnimal.name,
                "species": selectedAnimal.species,
                "breed": selectedAnimal.breed,
                "description": selectedAnimal.description,
                "owner": [
                    "uid": selectedAnimal.owner.uid
                ]
            ]
        ] as [String: Any]
        
        favouritesRef.setValue(favouriteAnimalObject) { (error, ref) in
            if error == nil {
                self.transitiontoHomeScreen()
                }
        }
    }
    
    func transitiontoHomeScreen() {
        let animalsListViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
        
        
        animalsListViewController?.modalPresentationStyle = .fullScreen
        animalsListViewController?.modalTransitionStyle = .crossDissolve
        present(animalsListViewController!, animated: false, completion: nil)
    }

    
}
