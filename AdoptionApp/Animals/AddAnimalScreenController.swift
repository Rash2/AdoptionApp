//
//  AddAnimalScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/10/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class AddAnimalScreenController: UIViewController {
    
    @IBOutlet weak var animalPictureView: UIImageView!
    @IBOutlet weak var tapToChangePictureButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
    }
    

    @IBAction func animalAdded(_ sender: Any) {
    }
    

}
