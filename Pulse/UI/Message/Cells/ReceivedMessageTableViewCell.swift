//
//  ReceivedMessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import ActiveLabel

class ReceivedMessageTableViewCell : MessageTableViewCell {

    @IBOutlet weak var message: ActiveLabel!
    
    func bind(conversation: Conversation, message: Message, colorMapper: GroupColorMapper) {
        super.bind(conversation: conversation, message: message)
        
        self.message.text = message.data
        self.message.textColor = UIColor.white
        self.createWebLinks(label: self.message, conversation: conversation)
        
        if conversation.isGroup() && message.sender != nil {
            self.timestamp.text = "\(self.timestamp.text!) - \(message.sender!)"
            
            let color = colorMapper.getColor(contactName: message.sender!)
            self.messageContainer.backgroundColor = UIColor(rgb: color)
            
            if (color.isColorDark()) {
                self.message.textColor = UIColor.white
            } else {
                self.message.textColor = UIColor.black
            }
        } else {
            self.messageContainer.backgroundColor = UIColor(rgb: conversation.color)
            
            if (conversation.color.isColorDark()) {
                self.message.textColor = UIColor.white
            } else {
                self.message.textColor = UIColor.black
            }
        }
    }
    
    override func createWebLinks(label: ActiveLabel, conversation: Conversation) {
        super.createWebLinks(label: label, conversation: conversation)
        label.URLColor = UIColor.white
    }
}
