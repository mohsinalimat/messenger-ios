//
//  ReceivedMessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import ActiveLabel

class ReceivedMessageTableViewCell: MessageTableViewCell {

    @IBOutlet weak var message: ActiveLabel!
    
    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        self.messageContainer.backgroundColor = UIColor(rgb: conversation.color)
        
        self.message.text = message.data
        self.message.textColor = UIColor.white
        self.createWebLinks(label: self.message, conversation: conversation)
        
        if (conversation.isGroup() && message.sender != nil) {
            self.timestamp.text = "\(self.timestamp.text!) - \(message.sender!)"
        }
    }
    
    override func createWebLinks(label: ActiveLabel, conversation: Conversation) {
        super.createWebLinks(label: label, conversation: conversation)
        label.URLColor = UIColor.white
    }
}
