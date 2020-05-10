//
//  AddAnimalScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/10/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class AddAnimalScreenController: UIViewController {
    
    @IBOutlet weak var animalPictureView: UIImageView!
    @IBOutlet weak var tapToChangePictureButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        animalPictureView.addGestureRecognizer(imageTap)
        animalPictureView.isUserInteractionEnabled = true
        tapToChangePictureButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func animalAdded(_ sender: Any) {
        if validateForm() {
            let animalRef = Database.database().reference().child("animals").childByAutoId()
            let keyValue = animalRef.key!
            let image = animalPictureView.image
            
            self.uploadAnimalPicture(image!, keyValue) { url in
                var photoURL: String?
                
                photoURL = url
                let animalObject = [
                    "photoURL": photoURL!,
                    "name": self.nameTextField.text!,
                    "species": self.speciesTextField.text!,
                    "breed": self.breedTextField.text!,
                    "age": Int(self.ageTextField.text!)!,
                    "description": self.descriptionTextField.text!
                ] as [String: Any]
                
                animalRef.setValue(animalObject, withCompletionBlock: { error, ref in
                    if error == nil {
                        self.transitiontoHomeScreen()
                    } else {
                        // Handle error
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = error!.localizedDescription
                        return
                    }
                })
            }
            
        }
    }
    
    func validateForm() -> Bool{
        guard nameTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in the animal's name"
            return false
        }
        
        guard speciesTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in the animal's species"
            return false
        }
        
        guard breedTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in the animal's breed"
            return false
        }
        
        guard ageTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in the animal's age"
            return false
        }
        
        guard descriptionTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in the animal's description"
            return false
        }
        
        guard isStringAnInt(string: ageTextField.text!) else {
            errorLabel.isHidden = false
            errorLabel.text = "Age is not a number"
            return false
        }
        
        return true
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func uploadAnimalPicture(_ image: UIImage,_ animalId: String ,completion: @escaping ((_ url: String?)->())) {
        
        let storageRef = Storage.storage().reference().child("animals/\(animalId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { metadata, error in
            guard metadata != nil else {
                return
            }
            storageRef.downloadURL { url, error in
                if error != nil {
                    completion(error!.localizedDescription)
                } else {
                    completion(url?.absoluteString)
                }
            }
        }
    }
    
    func transitiontoHomeScreen() {
        let animalsListViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? UINavigationController
        
        
        animalsListViewController?.modalPresentationStyle = .fullScreen
        animalsListViewController?.modalTransitionStyle = .crossDissolve
        present(animalsListViewController!, animated: false, completion: nil)
    }

}

extension AddAnimalScreenController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.editedImage] as? UIImage else {
            return
        }
        self.animalPictureView.image = pickedImage

        picker.dismiss(animated: true, completion: nil)
        
    }
}
