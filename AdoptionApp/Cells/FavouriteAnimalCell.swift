//
//  FavouriteAnimalCell.swift
//  AdoptionApp
//
//  Created by user169231 on 5/14/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class FavouriteAnimalCell: UITableViewCell {

    @IBOutlet weak var favouriteAnimalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    
    func setFavouriteAnimal(animal: Animal) {
        nameLabel.text = animal.name
        ageLabel.text = String(animal.age)
        breedLabel.text = animal.breed
        
        ImageService.getImage(withURL: animal.photoURL) { (image) in
            self.favouriteAnimalImageView.image = image
        }
    }
}
