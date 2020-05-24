//
//  MessageCell.swift
//  AdoptionApp
//
//  Created by user169231 on 5/24/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {


    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var messagePreviewLabel: UILabel!
    
    func setMessage(message: Message) {
        
        messageImageView.layer.cornerRadius = messageImageView.frame.size.width / 2
        messageImageView.clipsToBounds = true
        
        guard let currentUser = UserService.currentUser else { return }
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
            self.messageImageView.image = image
            
            if participant?.uid == message.receiverUID {
                self.participantLabel.text = "To: \(participant!.lastname) \(participant!.firstname)"
            } else {
                self.participantLabel.text = "From: \(participant!.lastname) \(participant!.firstname)"
                }
            
            if message.messageRead == false && message.receiverUID == currentUser.uid {
                self.participantLabel.text = "(NEW) " + self.participantLabel.text!
                }
            }
        }
        
        messagePreviewLabel.text = message.message
        
    }
    
}
