//
//  FavouriteAnimalsListScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/14/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class FavouriteAnimalsListScreenController: UIViewController {
    
    var animals = [Animal]()
    
    @IBOutlet weak var favouriteAnimalsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favouriteAnimalsTableView.delegate = self
        favouriteAnimalsTableView.dataSource = self
        favouriteAnimalsTableView.reloadData()
        observeAnimals()
    }
    
    func observeAnimals() {
        
        var tempAnimals = [Animal]()
        
        let animalsRef = Database.database().reference().child("favourites")
        guard let currentUser = UserService.currentUser else {return}
        
        animalsRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let animal = dict["animal"] as? [String: Any],
                    let addedByUser = dict["addedByUser"] as? String,
                    let owner = animal["owner"] as? [String: Any],
                    let uid = owner["uid"] as? String,
                    let firstname = owner["firstname"] as? String,
                    let lastname = owner["lastname"] as? String,
                    let city = owner["city"] as? String,
                    let street = owner["street"] as? String,
                    let age = animal["age"] as? Int,
                    let breed = animal["breed"] as? String,
                    let species = animal["species"] as? String,
                    let name = animal["name"] as? String,
                    let description = animal["description"] as? String,
                    let photoURL = animal["photoURL"] as? String,
                    let url = URL(string: photoURL),
                    addedByUser == currentUser.uid {
                    
                    let owner = User(uid: uid, photoURL: "None", firstname: firstname, lastname: lastname, city: city, street: street)
                    let animal = Animal(id: childSnapshot.key,owner: owner, photoURL: url, age: age, species: species, breed: breed, description: description, name: name)
                    
                    tempAnimals.append(animal)
                    
                }
            }
            self.animals = tempAnimals
            self.favouriteAnimalsTableView.reloadData()
        }
    }

}

extension FavouriteAnimalsListScreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animal = animals[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteAnimalCell") as! FavouriteAnimalCell
        cell.setFavouriteAnimal(animal: animal)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            performSegue(withIdentifier: "animalScreenToAnimalProfileSegue", sender: self)
//        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "animalScreenToAnimalProfileSegue" {
//            let indexPaths = self.animalsTableView!.indexPathsForSelectedRows!
//            let indexPath = indexPaths[0] as NSIndexPath
//            let animalProfile = segue.destination as! AnimalProfileScreenController
//            animalProfile.selectedAnimal = animals[indexPath.row]
//        }
//    }
    
}
