//
//  ReceivedMessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ReceivedMessageTableViewCell: MessageTableViewCell {

    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        self.messageContainer.backgroundColor = UIColor(rgb: conversation.color)
        self.message.textColor = UIColor.white
    }
}
