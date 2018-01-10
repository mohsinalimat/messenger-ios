//
//  MessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import ActiveLabel

class ScheduledMessageTableViewCell : MessageTableViewCell {
    
    @IBOutlet weak var message: ActiveLabel!
    
    func bind(message: ScheduledMessage) {
        self.timestamp.text = "\(message.title) - \(dateFormatter.string(from: Date(milliseconds: message.timestamp)))"
        self.messageContainer.backgroundColor = UIColor.groupTableViewBackground
        
        self.message.text = message.data
        self.message.textColor = UIColor.black
    }
}
