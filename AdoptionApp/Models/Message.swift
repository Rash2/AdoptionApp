//
//  Message.swift
//  AdoptionApp
//
//  Created by user169231 on 5/24/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import Foundation

class Message {
    var senderUID: String
    var receiverUID: String
    var message: String?
    var messageRead: Bool
    
    init(senderUID: String, receiverUID: String, message: String, messageRead: Bool) {
        self.senderUID = senderUID
        self.receiverUID = receiverUID
        self.message = message
        self.messageRead = messageRead
    }
}
