//
//  Blacklist.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Blacklist : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let id: Int64
    let phoneNumber: String
    
    var description: String {
        return "Blacklist: { phone_number: \(phoneNumber) }"
    }
    
    init(id: Int64, phoneNumber: String) {
        self.id = id
        self.phoneNumber = phoneNumber
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["device_id"] as? Int64,
            let phoneNumber = representation["phone_number"] as? String
        else { return nil }
        
        self.id = id
        self.phoneNumber = Account.encryptionUtils?.decrypt(data: phoneNumber) ?? ""
    }
}
