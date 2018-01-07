//
//  InfoTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/7/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class InfoTableViewCell: MessageTableViewCell {
    
    @IBOutlet weak var message: UILabel!
    
    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        self.message.text = message.data
        self.timestamp.isHidden = true
    }
}
