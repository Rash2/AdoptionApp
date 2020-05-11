//
//  AnimalCell.swift
//  AdoptionApp
//
//  Created by user169231 on 5/9/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func setAnimal(animal: Animal) {
        nameLabel.text = animal.name
        ageLabel.text = String(animal.age)
        breedLabel.text = animal.breed
        
        ImageService.getImage(withURL: animal.photoURL) { (image) in
            self.profileImage.image = image
        }
        
    }
}
