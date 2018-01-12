//
//  UnsupportedMediaTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/7/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class UnsupportedMediaTableViewCell : MessageTableViewCell {
    
    override func bind(conversation: Conversation, message: Message) {
        self.timestamp.isHidden = true
    }
}
