//
//  MessageScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/24/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class MessageScreenController: UIViewController {

    var message:Message!
    
    @IBOutlet weak var participantImageView: UIImageView!
    @IBOutlet weak var participantNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMessageScreen()
    }
    
    func setupMessageScreen() {
        guard let currentUser = UserService.currentUser else { return }
        
        participantImageView.layer.cornerRadius = participantImageView.frame.size.width / 2
        participantImageView.clipsToBounds = true
        
        var participantUID = ""
        var participant:User? = nil
        
        if currentUser.uid == message.senderUID {
            participantUID = message.receiverUID
        } else {
            participantUID = message.senderUID
        }
        
        let participantRef = Database.database().reference().child("users/\(participantUID)")
        participantRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any],
                let firstname = dict["firstname"] as? String,
                let lastname = dict["lastname"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let city = dict["city"] as? String,
                let street = dict["street"] as? String {
                    participant = User(uid: participantUID, photoURL: photoURL, firstname: firstname, lastname: lastname, city: city, street: street)
            }
            ImageService.getImage(withURL: participant!.photoURL) { (image) in
                self.participantImageView.image = image
            }
            
            if participant?.uid == self.message.receiverUID {
                self.participantNameLabel.text = "To: \(participant!.lastname) \(participant!.firstname)"
            } else {
                self.participantNameLabel.text = "From: \(participant!.lastname) \(participant!.firstname)"
                }
        }
        messageTextView.text = message.message
        if message.senderUID == currentUser.uid {
            replyButton.isEnabled = false
        }
    }

    @IBAction func replyButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "messageScreenToNewMessageScreenSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewMessageScreenController
        vc.receiverUID = message.senderUID
    }

}
