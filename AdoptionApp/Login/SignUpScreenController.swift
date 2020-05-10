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

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        error.isHidden = true
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let emailAddress = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let psw = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = username.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validateForm() == true {
            // Create user
            Auth.auth().createUser(withEmail: emailAddress, password: psw) { (result, err) in
                if err != nil {
                    self.error.isHidden = false
                    self.error.text = err!.localizedDescription
                    return
                } else {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = userName
                    changeRequest?.commitChanges { error in
                        if error != nil {
                            self.error.isHidden = false
                            self.error.text = err!.localizedDescription
                            return
                        } else {
                            // Transition to home screen
                            self.transitiontoHomeScreen()
                        }
                    }
                }
            }
        }
    }
    
    func transitiontoHomeScreen() {
        let animalsListViewController = storyboard?.instantiateViewController(identifier: "AnimalsListScreen") as? AnimalsListScreenController
        
        
        animalsListViewController?.modalPresentationStyle = .fullScreen
        animalsListViewController?.modalTransitionStyle = .crossDissolve
        present(animalsListViewController!, animated: false, completion: nil)
    }
    
    func validateForm() -> Bool {
        guard email.text?.count != 0 else {
            error.isHidden = false
            error.text = "Please fill in your email"
            return false
        }
        
        guard username.text?.count != 0 else {
            error.isHidden = false
            error.text = "Please fill in your username"
            return false
        }
        
        guard password.text?.count != 0 else {
            error.isHidden = false
            error.text = "Please fill in your password"
            return false
        }
        
        return true
    }
}