//
//  Conversations.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class ConversationsRoute : BaseRoute {
    
    init() {
        super.init(route: "conversations")
    }
    
    func getUnarchived(completionHandler: @escaping (DataResponse<[Conversation]>) -> Void) {
        if (!Account.exists()) {
            return
        }
        
        get(path: "/index_unarchived", parameters: ["account_id": Account.accountId!, "limit": 100])
            .responseCollection(completionHandler: completionHandler)
    }
    
    func archive(conversation: Conversation) {
        post(path: "/archive/\(conversation.id)")
    }
    
    func unarchive(conversation: Conversation) {
        post(path: "/unarchive/\(conversation.id)")
    }
    
    func delete(conversation: Conversation) {
        post(path: "/delete/\(conversation.id)")
    }
}
