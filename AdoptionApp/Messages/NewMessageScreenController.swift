//
//  NewMessageScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/24/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class NewMessageScreenController: UIViewController {
    
    
    @IBOutlet weak var receiverProfilePictureImageView: UIImageView!
    @IBOutlet weak var receiverInformationLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    var receiverUID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNewMessageScreen()
    }
    
    func setupNewMessageScreen() {
        receiverProfilePictureImageView.layer.cornerRadius = receiverProfilePictureImageView.frame.size.width / 2
        receiverProfilePictureImageView.clipsToBounds = true
        
        let userRef = Database.database().reference().child("users/\(receiverUID)")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any],
                let photoURL = dict["photoURL"] as? String,
                let photo = URL(string: photoURL),
                let firstname = dict["firstname"] as? String,
                let lastname = dict["lastname"] as? String {
                self.receiverInformationLabel.text = "To: \(lastname) \(firstname)"
                
                ImageService.getImage(withURL: photo) { (image) in
                    self.receiverProfilePictureImageView.image = image
                }
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let currentUser = UserService.currentUser else { return }
        
        let messagesRef = Database.database().reference().child("messages").childByAutoId()
        let messageObject = [
            "senderUID": currentUser.uid,
            "receiverUID": receiverUID,
            "message": messageTextView.text!,
            "readMessage": false,
        ] as [String: Any]
        
        messagesRef.setValue(messageObject) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "newMessageToMessageListSegue", sender: self)
            }
        }
    }
    
}
