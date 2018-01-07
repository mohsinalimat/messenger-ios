//
//  MessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import ActiveLabel

class SentMessageTableViewCell: MessageTableViewCell {
    
    @IBOutlet weak var message: ActiveLabel!
    
    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        self.messageContainer.backgroundColor = UIColor.groupTableViewBackground
        
        self.message.text = message.data
        self.message.textColor = UIColor.black
        self.createWebLinks(label: self.message, conversation: conversation)
    }
}
