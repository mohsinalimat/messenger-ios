//
//  FcmHandler.swift
//  Pulse
//
//  Created by Luke Klinker on 1/11/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import SwiftyJSON
import UserNotifications

let FcmHandler = _FcmHandler()

class _FcmHandler {
    
    func handle(operation: String, json: JSON) {
        switch operation {
        case "added_message":           addedMessage(json: json)
        case "read_conversation":       readConversation(json: json)
        case "added_conversation":      invalidateConversationList()
        case "removed_conversation":    invalidateConversationList()
        case "archive_conversation":    invalidateConversationList()
        case "dismissed_notification":  dismissNotification(json: json)
        default:                        throwAway(operation: operation, json: json)
        }
    }
    
    private func addedMessage(json: JSON) {
        let message = Message(json: json)
        debugPrint("added message: \(message.description)")
        
        if (json["sent_device"].stringValue != Account.deviceId!) {
            DataProvider.addMessage(conversationId: Int64(json["conversation_id"].stringValue)!, message: message)
        }
    }
    
    private func invalidateConversationList() {
        debugPrint("invalidate conversation list")
        
        DataProvider.clear()
        DataProvider.loadConversations()
    }
    
    private func readConversation(json: JSON) {
        debugPrint("read conversation: \(json["id"])")
        
        DataProvider.markAsRead(conversationId: Int64(json["id"].stringValue)!)
    }
    
    private func dismissNotification(json: JSON) {
        debugPrint("dismiss notifications")
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func throwAway(operation: String, json: JSON) {
        
    }
}
