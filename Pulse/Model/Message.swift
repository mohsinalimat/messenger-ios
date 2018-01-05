//
//  Message.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Message : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let id: Int64
    let messageType: Int
    let data: String
    let mimeType: String
    let timestamp: Int64
    
    var description: String {
        return "Message: { id: \(id), data: \(data), mimetype: \(mimeType), timestamp: \(timestamp) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["device_id"] as? Int64,
            let messageType = representation["message_type"] as? Int,
            let data = representation["data"] as? String,
            let mimeType = representation["mime_type"] as? String,
            let timestamp = representation["timestamp"] as? Int64
        else { return nil }
        
        self.id = id
        self.messageType = messageType
        self.data = Account.encryptionUtils?.decrypt(data: data) ?? ""
        self.mimeType = Account.encryptionUtils?.decrypt(data: mimeType) ?? "text/plain"
        self.timestamp = timestamp
    }
}

public class MessageType {
    public static let RECEIVED = 0
    public static let SENT = 1
    public static let SENDING = 2
    public static let ERROR = 3
    public static let DELIVERED = 4
    public static let INFO = 5
    public static let MEDIA = 6
}
