//
//  Contact.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Contact : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible, Equatable {
    
    let id: Int64
    let phoneNumber: String
    let name: String
    let idMatcher: String
    let color: Int
    
    var description: String {
        return "Contact: { phone_number: \(phoneNumber), name: \(name), id_matcher: \(idMatcher), color: \(color) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int64,
            let phoneNumber = representation["phone_number"] as? String,
            let name = representation["name"] as? String,
            let idMatcher = representation["id_matcher"] as? String,
            let color = representation["color"] as? Int
        else { return nil }
        
        self.id = id
        self.phoneNumber = Account.encryptionUtils?.decrypt(data: phoneNumber) ?? ""
        self.name = Account.encryptionUtils?.decrypt(data: name) ?? ""
        self.idMatcher = Account.encryptionUtils?.decrypt(data: idMatcher) ?? ""
        self.color = color
    }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
}
