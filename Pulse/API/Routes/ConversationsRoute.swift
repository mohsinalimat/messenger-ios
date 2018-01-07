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
    
    func latestTimestamp(completionHandler: @escaping (Int64) -> Void) {
        if (!Account.exists()) {
            return
        }
        
        get(path: "/latest_timestamp").responseString { response in
            if let timestamp = response.result.value {
                completionHandler(Int64(timestamp)!)
            }
        }
    }
    
    func getUnarchived(completionHandler: @escaping ([Conversation]) -> Void) {
        if (!Account.exists()) {
            return
        }
        
        get(path: "/index_unarchived", parameters: ["account_id": Account.accountId!, "limit": 100]).responseCollection { (response: DataResponse<[Conversation]>) in
            if let conversations = response.result.value {
                completionHandler(conversations)
            }
        }
    }
    
    func archive(conversation: Conversation) {
        post(path: "/archive/\(conversation.id)")
    }
    
    func unarchive(conversation: Conversation) {
        post(path: "/unarchive/\(conversation.id)")
    }
    
    func delete(conversation: Conversation) {
        post(path: "/remove/\(conversation.id)")
    }
}
