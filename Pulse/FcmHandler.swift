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
        default:                        debugPrint("no fcm handler for \(operation)")
        }
    }
    
    private func addedMessage(json: JSON) {
        let message = Message(json: json)
        DataProvider.addMessage(conversationId: json["conversation_id"].int64!, message: message)
    }
    
    private func invalidateConversationList() {
        DataProvider.clear()
        DataProvider.loadConversations()
    }
    
    private func readConversation(json: JSON) {
        DataProvider.markAsRead(conversationId: json["id"].int64!)
    }
    
    private func dismissNotification(json: JSON) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
