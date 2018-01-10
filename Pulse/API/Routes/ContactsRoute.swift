//
//  ContactRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class ContactsRoute : BaseRoute {
    
    init() {
        super.init(route: "contacts")
    }
    
    func getContacts(offset: Int = 0, completionHandler: @escaping ([Contact]) -> Void) {
        if (!Account.exists()) {
            return
        }
        
        get(path: "/simple", parameters: ["account_id": Account.accountId!, "limit": 500, "offset": offset])
            .responseCollection { (response: DataResponse<[Contact]>) in
                if let contacts = response.result.value {
                    completionHandler(contacts)
                }
            }
    }
}

