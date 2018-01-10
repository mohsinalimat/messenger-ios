//
//  MessagesRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class MessagesRoute : BaseRoute {
    
    init() {
        super.init(route: "messages")
    }
    
    func getMessages(conversationId: Int64, completionHandler: @escaping ([Message]) -> Void) {
        get(path: "", parameters: ["account_id": Account.accountId!, "conversation_id": conversationId, "web": true, "limit": 20]).responseCollection { (response: DataResponse<[Message]>) in
            if let messageList = response.result.value {
                completionHandler(messageList)
            }
        }
    }
    
    func send(conversation: Conversation, message: String, mimeType: String) -> Message {
        let message = Message(id: DataProvider.generateId(), messageType: MessageType.SENDING, data: message, mimeType: mimeType)
        
        post(path: "/add", parameters: [
            "account_id": Account.accountId!, "device_conversation_id": conversation.id, "device_id": message.id,
            "message_type": message.messageType, "data": Account.encryptionUtils!.encrypt(data: message.data), "timestamp": message.timestamp,
            "mime_type": Account.encryptionUtils!.encrypt(data: message.mimeType), "read": true, "seen": true, "sent_device": Account.deviceId!
        ])
        
        DataProvider.addSentMessage(conversation: conversation, message: message)
        return message
    }
    
    func forwardToPhone(phoneNumbers: String, message: String) {
        post(path: "/forward_to_phone", parameters: ["account_id": Account.accountId!, "to": phoneNumbers, "message": message])
    }

}
