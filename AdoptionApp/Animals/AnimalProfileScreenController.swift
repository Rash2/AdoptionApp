//
//  AnimalProfileScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/11/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

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
        }
    }
    
    
}
