//
//  CellIdentifier.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

class CellIdentifier {
    
    // TODO: handle media/info and error/sending/sent/delivered status
    static func get(message: Message) -> String {
        if (message.messageType == MessageType.RECEIVED) {
            return "ReceivedMessageTableViewCell"
        } else {
            return "SentMessageTableViewCell"
        }
    }
}
