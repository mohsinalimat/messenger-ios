//
//  BaseRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class BaseRoute {
    private let baseUrl: String
    
    init(route: String) {
        self.baseUrl = "https://api.messenger.klinkerapps.com/api/v1/\(route)"
    }
    
    @discardableResult func get(path: String, parameters: Parameters = ["account_id": Account.accountId!]) -> DataRequest {
        return Alamofire.request("\(baseUrl)\(path)", method: .get, parameters: parameters)
    }
    
    @discardableResult func post(path: String, parameters: Parameters = ["account_id": Account.accountId!]) -> DataRequest {
        return Alamofire.request("\(baseUrl)\(path)", method: .post, parameters: parameters)
    }
}
