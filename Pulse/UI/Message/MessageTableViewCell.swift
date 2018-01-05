//
//  MessageTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var timestamp: UILabel!
    
    private let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainer.layer.cornerRadius = 8
        messageContainer.layer.masksToBounds = true
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    func bind(conversation: Conversation, message: Message) {
        self.message.text = message.data
        self.timestamp.text = dateFormatter.string(from: Date(milliseconds: message.timestamp))
    }
}
