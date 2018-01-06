//
//  AppOpenedUpdateHelper.swift
//  Pulse
//
//  Created by Luke Klinker on 1/6/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import RxSwift

//
// When the app is opened, we need to check for updates, since iOS doesn't allow us to use data-based FCM messages in the background.
// Hopefully, we will know when new messages come in, through foreground FCM messages and that may be enough to keep our list up to date.
//

let AppOpenedUpdateHelper = _AppOpenedUpdateHelper()

class _AppOpenedUpdateHelper {
    
    private var latestTimestamp = Date().millisecondsSince1970
    private var conversationUpdateSubscription: Disposable? = nil
    
    var currentlyOpenConversation: Conversation? = nil
    
    func checkForConversationListUpdate() {
        PulseApi.conversations().latestTimestamp { timestamp in
            if (timestamp != self.latestTimestamp) {
                self.latestTimestamp = timestamp
                
                DataProvider.clear()
                self.watchCurrentConversationUpdate()
                DataProvider.loadConversations()
            }
        }
    }
    
    func resetLatestTimestamp(conversations: [Conversation]) {
        if (conversations.count == 0) {
            self.latestTimestamp = Date().millisecondsSince1970
        } else {
            let latestConversation = conversations.sorted(by: { (one, two) -> Bool in
                return one.timestamp > two.timestamp
            }).first!
            
            self.latestTimestamp = latestConversation.timestamp
        }
    }
    
    private func watchCurrentConversationUpdate() {
        self.conversationUpdateSubscription = DataObserver.conversations { event in
            self.conversationUpdateSubscription?.dispose()
            if let conversation = self.currentlyOpenConversation {
                if (!DataProvider.hasMessages(conversationId: conversation.id)) {
                    DataProvider.loadMessages(conversation: conversation)
                }
            }
        }
    }
}
