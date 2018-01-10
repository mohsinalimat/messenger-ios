//
//  ScheduledMessage.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct ScheduledMessage : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let id: Int64
    let title: String
    let to: String
    let data: String
    let mimeType: String
    let timestamp: Int64
    
    var description: String {
        return "Scheduled Message: { to: \(to), data: \(data), mime_type: \(mimeType), title: \(title), timestamp: \(timestamp) }"
    }
    
    init(id: Int64, title: String, phoneNumbers: String, data: String, mimeType: String, timestamp: Int64) {
        self.id = id
        self.title = title
        self.to = phoneNumbers
        self.data = data
        self.mimeType = mimeType
        self.timestamp = timestamp
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["device_id"] as? Int64,
            let to = representation["to"] as? String,
            let data = representation["data"] as? String,
            let mimeType = representation["mime_type"] as? String,
            let title = representation["title"] as? String,
            let timestamp = representation["timestamp"] as? Int64
        else { return nil }
        
        self.id = id
        self.to = Account.encryptionUtils?.decrypt(data: to) ?? ""
        self.data = Account.encryptionUtils?.decrypt(data: data) ?? ""
        self.mimeType = Account.encryptionUtils?.decrypt(data: mimeType) ?? ""
        self.title = Account.encryptionUtils?.decrypt(data: title) ?? ""
        self.timestamp = timestamp
    }
}

