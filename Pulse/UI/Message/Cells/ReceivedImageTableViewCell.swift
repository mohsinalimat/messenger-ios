//
//  ReceivedImageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/6/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import Kingfisher

class ReceivedImageTableViewCell : MessageTableViewCell {
    
    @IBOutlet weak var message: UIImageView!
    
    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        let url = URL(string: "https://api.messenger.klinkerapps.com/api/v1/media/\(message.id)?account_id=\(Account.accountId!)")!
        self.message.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
        self.messageContainer.backgroundColor = UIColor(rgb: conversation.color)
        self.message.backgroundColor = UIColor(rgb: conversation.color)
        
        if conversation.isGroup() && message.sender != nil {
            self.timestamp.text = "\(self.timestamp.text!) - \(message.sender!)"
        }
    }
}

