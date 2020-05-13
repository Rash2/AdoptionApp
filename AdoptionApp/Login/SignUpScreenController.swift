//
//  SignUpScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/7/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpScreenController: UIViewController {

    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var tapToChooseProfilePictureButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNamesTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSignUp()
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if validateForm() == true {
            let email = emailTextField.text!
            let firstnames = firstNamesTextField.text!
            let lastname = lastNameTextField.text!
            let city = cityTextField.text!
            let street = streetTextField.text!
            let password = passwordTextField.text!
            let profileImage = userProfilePictureImageView.image
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = error!.localizedDescription
                    return
                } else {
                    self.uploadUserProfilePicture(profileImage!) { (url) in
                        guard let uid = Auth.auth().currentUser?.uid else {return}
                        let userRef = Database.database().reference().child("users/\(uid)")
                        
                        let userObject = [
                            "photoURL": url,
                            "firstname": firstnames,
                            "lastname": lastname,
                            "city": city,
                            "street": street
                        ] as [String: Any]
                        userRef.setValue(userObject) { (error, ref) in
                            if error == nil {
                                self.transitiontoHomeScreen()
                            } else {
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
    
    
    func setupSignUp() {
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
        tapToChooseProfilePictureButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadUserProfilePicture(_ image: UIImage, completion: @escaping ((_ url: String?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
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
        let animalsListViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
        
        
        animalsListViewController?.modalPresentationStyle = .fullScreen
        animalsListViewController?.modalTransitionStyle = .crossDissolve
        present(animalsListViewController!, animated: false, completion: nil)
    }
    
    func validateForm() -> Bool {
        guard emailTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your email"
            return false
        }
        
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
        
        guard streetTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your street"
            return false
        }
        
        guard passwordTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please fill in your password"
            return false
        }
        
        guard confirmPasswordTextField.text?.count != 0 else {
            errorLabel.isHidden = false
            errorLabel.text = "Please confirm your password"
            return false
        }
        
        guard passwordTextField.text! == confirmPasswordTextField.text! else {
            errorLabel.isHidden = false
            errorLabel.text = "Passwords do not match"
            return false
        }
        
        return true
    }
}

extension SignUpScreenController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
