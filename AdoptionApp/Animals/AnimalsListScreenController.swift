//
//  AnimalsListScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/9/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class AnimalsListScreenController: UIViewController {
    
    var animals: [Animal] = []
    
    @IBOutlet weak var animalsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animals = createArray()
        
        animalsTableView.delegate = self
        animalsTableView.dataSource = self
    }
    

    func createArray() -> [Animal] {
        var temp: [Animal] = []
        
        let animal1 = Animal(photoURL: "https://imgur.com/r/animals/sPlUl2Q", age: 5,species: "Dog",breed: "German Shepherd",description: "cool dog", name: "Rexx", ownerAddress: "Prahova, Ploiesti, Str. Anul 1907, nr. 6",ownerId: "id1");
        let animal2 = Animal(photoURL: "https://imgur.com/r/animals/sPlUl2Q",age: 5,species: "Dog",breed: "German Shepherd", description: "cool dog", name: "Rexx", ownerAddress: "Prahova, Ploiesti, Str. Anul 1907, nr. 6",ownerId: "id1")
        let animal3 = Animal(photoURL: "https://imgur.com/r/animals/sPlUl2Q",age: 5,species: "Dog",breed: "German Shepherd", description: "cool dog", name: "Rexx", ownerAddress: "Prahova, Ploiesti, Str. Anul 1907, nr. 6",ownerId: "id1")
        
        temp.append(animal1)
        temp.append(animal2)
        temp.append(animal3)
        
        return temp
    }

}

extension AnimalsListScreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animal = animals[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell") as! AnimalCell
        cell.setAnimal(animal: animal)
        
        return cell
    }
}
