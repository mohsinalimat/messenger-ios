//
//  NotificationService.swift
//  NotificationDecryptor
//
//  Created by Luke Klinker on 1/12/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // TODO: why isn't the decryption working? It seems like our extension is never hitting this code
        let encryptor = Account.encryptionUtils!
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = encryptor.decrypt(bestAttemptContent.title) ?? ""
            bestAttemptContent.body = encryptor.decrypt(bestAttemptContent.body) ?? ""
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
