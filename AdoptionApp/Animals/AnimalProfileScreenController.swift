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
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var animalPictureView: UIImageView!
    
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
        
        ImageService.getImage(withURL: selectedAnimal.photoURL) { (image) in
            self.animalPictureView.image = image
        }
    }
    
}
