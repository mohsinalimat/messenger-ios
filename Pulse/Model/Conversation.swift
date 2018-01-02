//
//  Conversation.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Conversation: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    let title: String
    let snippet: String
    let timestamp: Int64
    let color: Int
    let colorDark: Int
    let colorAccent: Int
    
    var description: String {
        return "Conversation: { title: \(title), snippet: \(snippet), timestamp: \(timestamp) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let title = representation["title"] as? String,
            let snippet = representation["snippet"] as? String,
            let timestamp = representation["timestamp"] as? Int64,
            let color = representation["color"] as? Int,
            let colorDark = representation["color_dark"] as? Int,
            let colorAccent = representation["color_accent"] as? Int
        else { return nil }
        
        self.title = Account.encryptionUtils?.decrypt(data: title) ?? ""
        self.snippet = Account.encryptionUtils?.decrypt(data: snippet) ?? ""
        self.timestamp = timestamp
        self.color = color
        self.colorDark = colorDark
        self.colorAccent = colorAccent
    }
}

