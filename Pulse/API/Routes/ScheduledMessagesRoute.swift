//
//  ScheduledMessageRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class ScheduledMessagesRoute : BaseRoute {

    init() {
        super.init(route: "scheduled_messages")
    }
    
    func getMessages(completionHandler: @escaping ([ScheduledMessage]) -> Void) {
        if !Account.exists() {
            return
        }
        
        get(path: "").responseCollection { (response: DataResponse<[ScheduledMessage]>) in
            if let messages = response.result.value {
                completionHandler(messages)
            }
        }
    }
    
    func delete(message: ScheduledMessage) {
        post(path: "/remove/\(message.id)")
    }
    
    func add(title: String, phoneNumbers: String, text: String, timestamp: Int64) -> ScheduledMessage {
        let message = ScheduledMessage(id: DataProvider.generateId(), title: title, phoneNumbers: phoneNumbers, data: text, mimeType: MimeType.TEXT_PLAIN, timestamp: timestamp)
        
        post(path: "/add", parameters: [
            "account_id": Account.accountId!, "device_id": message.id, "title": message.title, "to": message.to,
            "data": message.data, "mime_type": message.mimeType, "timestamp": message.timestamp
        ])
        
        DataProvider.addScheduledMessage(message: message)
        return message
    }
}
