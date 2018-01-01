//
//  LoginResponse.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct LoginResponse: ResponseObjectSerializable, CustomStringConvertible {
    let accountId: String
    let name: String
    let number: String
    let salt1: String
    let salt2: String
    
    var description: String {
        return "LoginResponse: { account_id: \(accountId), name: \(name), number: \(number), salts: [\(salt1), \(salt2)] }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let accountId = representation["account_id"] as? String,
            let name = representation["name"] as? String,
            let number = representation["phone_number"] as? String,
            let salt1 = representation["salt1"] as? String,
            let salt2 = representation["salt2"] as? String
        else { return nil }
        
        self.accountId = accountId
        self.name = name
        self.number = number
        self.salt1 = salt1
        self.salt2 = salt2
    }
}
