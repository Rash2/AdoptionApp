//
//  AnimalCell.swift
//  AdoptionApp
//
//  Created by user169231 on 5/9/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {



    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    func setAnimal(animal: Animal) {
        speciesLabel.text = animal.species
        ageLabel.text = String(animal.age)
        cityLabel.text = animal.owner.city
        
        ImageService.getImage(withURL: animal.photoURL) { (image) in
            self.profileImage.image = image
        }
        
    }
}
