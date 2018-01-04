//
//  AccountRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class AccountsRoute : BaseRoute {
    
    init() {
        super.init(route: "accounts")
    }
    
    func login(email: String, password: String, completionHandler: @escaping (DataResponse<LoginResponse>) -> Void) {
        post(path: "login", parameters: ["username": email, "password": password])
            .responseObject(completionHandler: completionHandler)
    }
}
