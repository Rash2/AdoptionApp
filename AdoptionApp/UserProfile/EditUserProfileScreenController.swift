//
//  EditUserProfileScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/13/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class EditUserProfileScreenController: UIViewController {
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var tapToChoosePictureButton: UIButton!
    
    @IBOutlet weak var firstNamesTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupEditProfileScreen()
    }
    
    func setupEditProfileScreen() {
        errorLabel.isHidden = true
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.size.width / 2
        userProfilePictureImageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        userProfilePictureImageView.addGestureRecognizer(imageTap)
        userProfilePictureImageView.isUserInteractionEnabled = true
        tapToChoosePictureButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        guard let currentUser = UserService.currentUser else { return }
        firstNamesTextField.text = currentUser.firstname
        lastNameTextField.text = currentUser.lastname
        cityTextField.text = currentUser.city
        streetTextField.text = currentUser.street
        
        ImageService.getImage(withURL: currentUser.photoURL) { (image) in
            self.userProfilePictureImageView.image = image
        }
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        
        guard firstNamesTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your first name(s)"
            return false
        }
        
        guard lastNameTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your last name"
            return false
        }
        
        guard cityTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your city"
            return false
        }
        
        guard cityTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your street"
            return false
        }
        
        return true
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        guard let currentUser = UserService.currentUser else {return}
        if validateForm() == true {
            let firstNames = firstNamesTextField.text!
            let lastName = lastNameTextField.text!
            let city = cityTextField.text!
            let street = streetTextField.text!
            let image = userProfilePictureImageView.image!
            
            let userRef = Database.database().reference()
            let animalsRef = Database.database().reference().child("animals")
            
            replaceUserProfilePicture(image) { (imageURL) in
                let userObject = [
                    "photoURL": imageURL!,
                    "firstname": firstNames,
                    "lastname": lastName,
                    "city": city,
                    "street": street
                ] as [String: Any]
                
                let ownerObject = [
                    "uid": currentUser.uid,
                    "firstname": firstNames,
                    "lastname": lastName,
                    "city": city,
                    "street": street
                ] as [String: Any]
                
                let childUpdates = [
                    "users/\(currentUser.uid)": userObject,
                ]
                
                // TO-DO update owners
                userRef.updateChildValues(childUpdates) { (error, ref) in
                    if error != nil {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = error!.localizedDescription
                        return
                    } else {
                        animalsRef.observeSingleEvent(of: .value) { (snapshot) in
                            for child in snapshot.children {
                                if let childSnapshot = child as? DataSnapshot,
                                    let dict = childSnapshot.value as? [String: Any],
                                    let owner = dict["owner"] as? [String: Any],
                                    let ownerUID = owner["uid"] as? String,
                                    currentUser.uid == ownerUID {
                                    let ownerUpdates = [
                                        "\(childSnapshot.key)/owner": ownerObject
                                    ]
                                    animalsRef.updateChildValues(ownerUpdates) { (error, ref) in
                                        if error != nil {
                                            self.errorLabel.isHidden = false
                                            self.errorLabel.text = error!.localizedDescription
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    func replaceUserProfilePicture(_ image: UIImage, completion: @escaping ((_ url: String?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users")
        let userPictureRef = storageRef.child("\(uid)")
        
        userPictureRef.delete { (error) in
            if error != nil {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error!.localizedDescription
                return
            }
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child("\(uid)").putData(imageData, metadata: metaData) { metadata, error in
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
    
}

extension EditUserProfileScreenController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.editedImage] as? UIImage else {
            return
        }
        self.userProfilePictureImageView.image = pickedImage

        picker.dismiss(animated: true, completion: nil)
        
    }
}
