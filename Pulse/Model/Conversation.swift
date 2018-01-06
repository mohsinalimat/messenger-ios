//
//  Conversation.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Conversation: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let id: Int64
    let title: String
    let phoneNumbers: String
    let snippet: String
    let timestamp: Int64
    let pinned: Bool
    let color: Int
    let colorDark: Int
    let colorAccent: Int
    
    var description: String {
        return "Conversation: { title: \(title), snippet: \(snippet), timestamp: \(timestamp) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["device_id"] as? Int64,
            let title = representation["title"] as? String,
            let phoneNumbers = representation["phone_numbers"] as? String,
            let snippet = representation["snippet"] as? String,
            let timestamp = representation["timestamp"] as? Int64,
            let pinned = representation["pinned"] as? Bool,
            let color = representation["color"] as? Int,
            let colorDark = representation["color_dark"] as? Int,
            let colorAccent = representation["color_accent"] as? Int
        else { return nil }
        
        self.id = id
        self.title = Account.encryptionUtils?.decrypt(data: title) ?? ""
        self.phoneNumbers = Account.encryptionUtils?.decrypt(data: phoneNumbers) ?? ""
        self.snippet = Account.encryptionUtils?.decrypt(data: snippet) ?? ""
        self.timestamp = timestamp
        self.pinned = pinned
        self.color = color
        self.colorDark = colorDark
        self.colorAccent = colorAccent
    }
    
    func isGroup() -> Bool {
        return phoneNumbers.contains(",")
    }
}
