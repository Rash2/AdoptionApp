//
//  AnimalsListScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/9/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class AnimalsListScreenController: UIViewController {
    
    var animals = [Animal]()
    var currentAnimals = [Animal]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var animalsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animalsTableView.delegate = self
        animalsTableView.dataSource = self
        animalsTableView.reloadData()
        observeAnimals()
        setupSearchBar()
    }
    

    func observeAnimals() {
        
        var tempAnimals = [Animal]()
        
        let animalsRef = Database.database().reference().child("animals")
        
        animalsRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let owner = dict["owner"] as? [String: Any],
                    let uid = owner["uid"] as? String,
                    let firstname = owner["firstname"] as? String,
                    let lastname = owner["lastname"] as? String,
                    let city = owner["city"] as? String,
                    let street = owner["street"] as? String,
                    let age = dict["age"] as? Int,
                    let breed = dict["breed"] as? String,
                    let species = dict["species"] as? String,
                    let name = dict["name"] as? String,
                    let description = dict["description"] as? String,
                    let photoURL = dict["photoURL"] as? String,
                    let url = URL(string: photoURL){
                    
                    let owner = User(uid: uid, photoURL: "None", firstname: firstname, lastname: lastname, city: city, street: street)
                    let animal = Animal(id: childSnapshot.key,owner: owner, photoURL: url, age: age, species: species, breed: breed, description: description, name: name)
                    
                    tempAnimals.append(animal)
                    
                } 
            }
            self.animals = tempAnimals
            self.currentAnimals = tempAnimals
            self.animalsTableView.reloadData()
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    

}

extension AnimalsListScreenController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animal = currentAnimals[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell") as! AnimalCell
        cell.setAnimal(animal: animal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            performSegue(withIdentifier: "animalScreenToAnimalProfileSegue", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "animalScreenToAnimalProfileSegue" {
            let indexPaths = self.animalsTableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            let animalProfile = segue.destination as! AnimalProfileScreenController
            animalProfile.selectedAnimal = animals[indexPath.row]
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        currentAnimals = animals.filter({ (animal) -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return animal.species.lowercased().contains(searchText.lowercased()) || animal.owner.city.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return animal.age <= 5 }
                return (animal.species.lowercased().contains(searchText.lowercased()) || animal.owner.city.lowercased().contains(searchText.lowercased())) && animal.age <= 5
            case 2:
                if searchText.isEmpty { return animal.age > 5 }
                return (animal.species.lowercased().contains(searchText.lowercased()) || animal.owner.city.lowercased().contains(searchText.lowercased())) && animal.age > 5
            default:
                return false
            }
        })
        
        animalsTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentAnimals = animals
        case 1:
            currentAnimals = animals.filter({ (animal) -> Bool in
                animal.age <= 5
            })
        case 2:
            currentAnimals = animals.filter({ (animal) -> Bool in
                animal.age > 5
            })
        default:
            break
        }
        animalsTableView.reloadData()
    }
    
}
