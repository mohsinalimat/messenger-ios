//
//  BlacklistRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class BlacklistsRoute : BaseRoute {

    init() {
        super.init(route: "blacklists")
    }
    
    func getBlacklists(completionHandler: @escaping ([Blacklist]) -> Void) {
        if (!Account.exists()) {
            return
        }
        
        get(path: "").responseCollection { (response: DataResponse<[Blacklist]>) in
            if let blacklists = response.result.value {
                completionHandler(blacklists)
            }
        }
    }
    
    func delete(blacklist: Blacklist) {
        post(path: "/remove/\(blacklist.id)")
    }
    
    func add(phoneNumber: String) -> Blacklist {
        let blacklist = Blacklist(id: DataProvider.generateId(), phoneNumber: phoneNumber)
        post(path: "/add", parameters: ["account_id": Account.accountId!, "device_id": blacklist.id, "phone_number": blacklist.phoneNumber])
        
        DataProvider.addBlacklist(blacklist: blacklist)
        return blacklist
    }
    
}
