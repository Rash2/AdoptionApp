//
//  LoginScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/7/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class LoginScreenController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        error.isHidden = true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let emailAddress = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let psw = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validateForm() == true {
            //Login user
            Auth.auth().signIn(withEmail: emailAddress, password: psw) { (result, err) in
                if err != nil {
                    self.error.isHidden = false
                    self.error.text = err!.localizedDescription
                } else {
                    self.transitiontoHomeScreen()
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
    
    func validateForm() -> Bool{
        guard email.text?.count != 0 else {
            error.isHidden = false
            error.text = "Please fill in your email"
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
