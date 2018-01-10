//
//  MessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import ActiveLabel

class MessageTableViewCell : UITableViewCell {
    
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var timestamp: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainer.layer.cornerRadius = 8
        messageContainer.layer.masksToBounds = true
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    func bind(conversation: Conversation, message: Message) {
        self.timestamp.text = dateFormatter.string(from: Date(milliseconds: message.timestamp))
    }
    
    internal func createWebLinks(label: ActiveLabel, conversation: Conversation) {
        label.URLColor = UIColor(rgb: conversation.colorAccent)
        label.urlMaximumLength = 30
        label.handleURLTap {
            if let url = URL(string: $0.absoluteString) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
