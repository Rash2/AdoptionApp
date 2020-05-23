//
//  NotificationsScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/23/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit
import Firebase

class NotificationsScreenController: UIViewController {
    
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    var notifications = [[String: Any]]()
    var countUnreadNotifications = 0
    var uid:String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.reloadData()
        observeNotifications()
    }
    
    func observeNotifications() {
        var tempNotifications = [[String: Any]]()
        guard let currentUser = UserService.currentUser else {return}
        
        let notificationsRef = Database.database().reference().child("notifications")
        notificationsRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let notification = childSnapshot.value as? [String: Any],
                    let addedByUser = notification["addedByUser"] as? String,
                    let animalName = notification["animalName"] as? String,
                    let ownerUID = notification["owner"] as? String,
                    let readNotification = notification["readNotification"] as? Bool,
                    currentUser.uid == ownerUID {
                    
                    let newNotification = [
                        "id": childSnapshot.key,
                        "addedByUser": addedByUser,
                        "animalName": animalName,
                        "ownerUid": ownerUID,
                        "readNotification": readNotification
                    ] as [String:Any]
                    
                    tempNotifications.append(newNotification)
                    if readNotification == false {
                        self.countUnreadNotifications += 1
                    }
                }
            }
            self.notifications = tempNotifications.reversed()
            if self.countUnreadNotifications > 0 {
                self.navigationController!.tabBarItem.badgeValue = String(self.countUnreadNotifications)
            }
            self.notificationsTableView.reloadData()
        }
    }

}

extension NotificationsScreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animalName = notifications[indexPath.row]["animalName"] as! String
        let readNotif = notifications[indexPath.row]["readNotification"] as! Bool
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.setNotification(animalName: animalName, read: readNotif)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationId = notifications[indexPath.row]["id"] as! String
        let notificationsRef = Database.database().reference()
        uid = notifications[indexPath.row]["addedByUser"] as? String
        
        let updatedNotificationObject = [
            "addedByUser": notifications[indexPath.row]["addedByUser"] as! String,
            "owner": notifications[indexPath.row]["ownerUid"] as! String,
            "animalName": notifications[indexPath.row]["animalName"] as! String,
            "readNotification": true
        ] as [String: Any]
        
        let childUpdates = [
            "notifications/\(notificationId)": updatedNotificationObject
        ]
        
        if countUnreadNotifications > 0 {
            countUnreadNotifications -= 1
            navigationController!.tabBarItem.badgeValue = String(countUnreadNotifications)
        } else {
            navigationController!.tabBarItem.badgeValue = nil
        }
        
        notificationsRef.updateChildValues(childUpdates) { (error, ref) in
            if error == nil {
                self.performSegue(withIdentifier: "notificationsScreenToOwnerProfileSegue", sender: self)
            }
        }
        
        notificationsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! OwnerProfileScreenController
        vc.ownerUid = uid!
    }
}
