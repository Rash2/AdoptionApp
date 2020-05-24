//
//  MessagesListScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/24/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class MessagesListScreenController: UIViewController {
    
    var messages = [Message]()
    var messageIds = [String]()
    
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.reloadData()
        observeMessages()
    }

    func observeMessages() {
        var tempMessages = [Message]()
        var tempMessageIds = [String]()
        guard let currentUser = UserService.currentUser else { return }
        
        let messagesRef = Database.database().reference().child("messages")
        messagesRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let senderUID = dict["senderUID"] as? String,
                    let receiverUID = dict["receiverUID"] as? String,
                    let message = dict["message"] as? String,
                    let messageRead = dict["readMessage"] as? Bool,
                    currentUser.uid == senderUID || currentUser.uid == receiverUID {
                        let newMessage = Message(senderUID: senderUID, receiverUID: receiverUID, message: message, messageRead: messageRead)
                        tempMessages.append(newMessage)
                    tempMessageIds.append(childSnapshot.key)
                }
            }
            self.messages = tempMessages.reversed()
            self.messageIds = tempMessageIds.reversed()
            self.messagesTableView.reloadData()
        }
    }

}

extension MessagesListScreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.setMessage(message: message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let currentUser = UserService.currentUser else { return }
        if message.messageRead == false && message.receiverUID == currentUser.uid {
            let messageId = messageIds[indexPath.row]
            let messagesRef = Database.database().reference()
            
            let updatedMessageObject = [
                "message": message.message! as String,
                "senderUID": message.senderUID as String,
                "receiverUID": message.receiverUID as String,
                "readMessage": true
            ] as [String: Any]
            
            let childUpdates = [
                "messages/\(messageId)": updatedMessageObject
            ]
            
            messagesRef.updateChildValues(childUpdates)
        }
        
        performSegue(withIdentifier: "messagesListToMessageScreenSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesListToMessageScreenSegue" {
            let indexPaths = self.messagesTableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            let messageScreen = segue.destination as! MessageScreenController
            messageScreen.message = messages[indexPath.row]
        }
    }
    
}
