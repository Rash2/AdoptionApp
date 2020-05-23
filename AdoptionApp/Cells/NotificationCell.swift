//
//  NotificationCell.swift
//  AdoptionApp
//
//  Created by user169231 on 5/23/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationTitleLabel: UILabel!
    
    
    func setNotification(animalName: String, read: Bool) {
        notificationTitleLabel.text = "Someone just added \(animalName) to their favourites!"
        
        if read == true {
            notificationTitleLabel.font = notificationTitleLabel.font.withSize(16)
        }
    }

}
