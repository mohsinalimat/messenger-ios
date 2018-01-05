//
//  DataProvider.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

let DataProvider = _DataProvider()

class _DataProvider {
    
    private var conversations: [Conversation]? = nil
    private var messages = [Int64: [Message]]()
    
    func clear() {
        conversations = nil
        messages = [Int64: [Message]]()
    }
    
    func conversations(completed: @escaping ([Conversation]) -> Void) {
        if (conversations != nil) {
            completed(conversations!)
        } else {
            PulseApi.conversations().getUnarchived { (response: DataResponse<[Conversation]>) in
                if let conversations = response.result.value {
                    self.conversations = conversations
                    completed(conversations)
                } else {
                    completed([Conversation]())
                }
            }
        }
    }
    
    func messages(conversation: Conversation, completed: @escaping ([Message]) -> Void) {
        if let messageList = messages[conversation.id] {
            completed(messageList)
        } else {
            PulseApi.messages().getMessages(conversationId: conversation.id) { (response: DataResponse<[Message]>) in
                if let messageList = response.result.value {
                    self.messages.updateValue(messageList, forKey: conversation.id)
                    completed(messageList)
                } else {
                    completed([Message]())
                }
            }
        }
    }
    
    func hasMessages(conversation: Conversation) -> Bool {
        return messages[conversation.id] != nil
    }
    
    func clearMessages(conversation: Conversation) {
        messages[conversation.id] = nil
    }
}
