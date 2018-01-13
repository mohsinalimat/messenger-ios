//
//  DataProvider.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

//
// The goal of this is to provide an interface for caching data, updating data, and updating the UI based on the new data.
// Anyone can subscribe to the conversation list updates, or the message list updates and they will get notified automatically of new data.
// This means that they only need to manage the UI in one place, rather than providing different UI update methods every time they query data.
// This is pushing the data to those observables, rather than them trying to pull in the data when they *think* there could have been an update.
//
//
// USAGE:
//
// Anyone can subscribe using, for example, DataObserver.conversations { conversations in ... }. Conversations will contain the event that holds
// the conversation list and get called whenever
//
// Anyone can also choose to update the backing data through DataProvider.loadConversations(). The load will pull in the cached data if it exists.
// If the cached list is nil, it will query the Pulse APIs. Anyone subscribed to that conversation list will get notified when the load is
// completed, rather than you telling the app what you want to do, when the load is completed.
//

let DataObserver = _DataObserver()
let DataProvider = _DataProvider()

class _DataObserver {
    
    private let conversationsObservable = PublishSubject<[Conversation]>()
    private let archiveObservable = PublishSubject<[Conversation]>()
    private let scheduledMessagesObservable = PublishSubject<[ScheduledMessage]>()
    private let blacklistsObservable = PublishSubject<[Blacklist]>()
    private var messagesObservable = [Int64: PublishSubject<[Message]>]()

    func conversations(onNext: @escaping ([Conversation]) -> Void) -> Disposable {
        return self.conversationsObservable.subscribe { event in
            onNext(event.element!)
        }
    }
    
    func archive(onNext: @escaping ([Conversation]) -> Void) -> Disposable {
        return self.archiveObservable.subscribe { event in
            onNext(event.element!)
        }
    }
    
    func scheduledMessages(onNext: @escaping ([ScheduledMessage]) -> Void) -> Disposable {
        return self.scheduledMessagesObservable.subscribe { event in
            onNext(event.element!)
        }
    }
    
    func blacklists(onNext: @escaping ([Blacklist]) -> Void) -> Disposable {
        return self.blacklistsObservable.subscribe { event in
            onNext(event.element!)
        }
    }
    
    func messages(conversation: Conversation, onNext: @escaping ([Message]) -> Void) -> Disposable {
        if let publisher = messagesObservable[conversation.id] {
            return publisher.subscribe { event in
                onNext(event.element!)
            }
        } else {
            let publisher = PublishSubject<[Message]>()
            messagesObservable.updateValue(publisher, forKey: conversation.id)
            
            return publisher.subscribe { event in
                onNext(event.element!)
            }
        }
    }
    
    fileprivate func notifyConversations(conversations: [Conversation]) {
        conversationsObservable.onNext(conversations)
    }
    
    fileprivate func notifyArchive(conversations: [Conversation]) {
        archiveObservable.onNext(conversations)
    }
    
    fileprivate func notifyScheduledMessages(messages: [ScheduledMessage]) {
        scheduledMessagesObservable.onNext(messages)
    }
    
    fileprivate func notifyBlacklists(blacklists: [Blacklist]) {
        blacklistsObservable.onNext(blacklists)
    }
    
    fileprivate func notifyMessages(conversationId: Int64, messages: [Message]) {
        if let publisher = messagesObservable[conversationId] {
            publisher.onNext(messages)
        }
    }
}

class _DataProvider {
    
    private var conversations: [Conversation]? = nil
    private var archive: [Conversation]? = nil
    private var scheduledMessages: [ScheduledMessage]? = nil
    private var blacklists: [Blacklist]? = nil
    private var messages = [Int64: [Message]]()
    var contacts = [Contact]()
    
    func clear() {
        conversations = nil
        archive = nil
        scheduledMessages = nil
        blacklists = nil
    }
    
    func clearMessages(conversation: Conversation) {
        messages[conversation.id] = nil
    }
    
    func loadConversations() {
        if conversations != nil {
            DataObserver.notifyConversations(conversations: conversations!)
        } else {
            PulseApi.conversations().getUnarchived { conversations in
                self.conversations = conversations
                DataObserver.notifyConversations(conversations: conversations)
                AppOpenedUpdateHelper.resetLatestTimestamp(conversations: conversations)
            }
        }
    }
    
    func loadArchive() {
        if archive != nil {
            DataObserver.notifyArchive(conversations: conversations!)
        } else {
            PulseApi.conversations().getArchived { conversations in
                self.archive = conversations
                DataObserver.notifyArchive(conversations: conversations)
            }
        }
    }
    
    func loadScheduledMessages() {
        if scheduledMessages != nil {
            DataObserver.notifyScheduledMessages(messages: scheduledMessages!)
        } else {
            PulseApi.scheduledMessages().getMessages { messages in
                self.scheduledMessages = messages
                DataObserver.notifyScheduledMessages(messages: messages)
            }
        }
    }
    
    func loadBlacklists() {
        if blacklists != nil {
            DataObserver.notifyBlacklists(blacklists: blacklists!)
        } else {
            PulseApi.blacklists().getBlacklists { blacklists in
                self.blacklists = blacklists
                DataObserver.notifyBlacklists(blacklists: blacklists)
            }
        }
    }
    
    func loadMessages(conversation: Conversation) {
        if hasMessages(conversationId: conversation.id) {
            DataObserver.notifyMessages(conversationId: conversation.id, messages: messages[conversation.id]!)
        } else {
            PulseApi.messages().getMessages(conversationId: conversation.id) { messageList in
                let messages = messageList.uniq()
                self.messages.updateValue(messages, forKey: conversation.id)
                DataObserver.notifyMessages(conversationId: conversation.id, messages: messages)
            }
        }
    }
    
    func loadContacts(offset: Int = 0) {
        if self.contacts.count % 500 != 0 {
            // there is a bug here. If the user has exactly any increment of 500,
            // it would just continue to run through the contact load.
            
            self.contacts = self.contacts.uniq()
            return
        }
        
        PulseApi.contacts().getContacts(offset: offset) { contacts in
            self.contacts.append(contentsOf: contacts)
            self.loadContacts(offset: self.contacts.count)
        }
    }
    
    func addSentMessage(conversationId: Int64, message: Message) {
        messages[conversationId]?.insert(message, at: 0)
        
        for i in 0..<conversations!.count {
            if (conversations![i].id == conversationId) {
                conversations![i].snippet = message.mimeType == MimeType.TEXT_PLAIN ? "You: \(message.data)" : ""
                conversations![i].timestamp = message.timestamp
                conversations![i].read = true
                
                DataObserver.notifyConversations(conversations: conversations!)
                PulseApi.conversations().updateSnippet(conversation: conversations![i], snippet: conversations![i].snippet)
                
                break
            }
        }
    }
    
    func addMessage(conversationId: Int64, message: Message) {
        if !hasMessages(conversationId: conversationId) {
            return
        }
        
        messages[conversationId]!.insert(message, at: 0)
        DataObserver.notifyMessages(conversationId: conversationId, messages: messages[conversationId]!)
        
        if conversations == nil {
            return
        }
        
        for i in 0..<conversations!.count {
            if (conversations![i].id == conversationId) {
                conversations![i].timestamp = message.timestamp
                conversations![i].snippet = message.mimeType == MimeType.TEXT_PLAIN ? message.data : ""
                if message.messageType != MessageType.RECEIVED {
                    conversations![i].snippet = "You: \(conversations![i].snippet)"
                    conversations![i].read = true
                } else {
                    conversations![i].read = false
                }
                
                DataObserver.notifyConversations(conversations: conversations!)
                break
            }
        }
    }
    
    func addBlacklist(blacklist: Blacklist) {
        self.blacklists?.append(blacklist)
        DataObserver.notifyBlacklists(blacklists: self.blacklists!)
    }
    
    func addScheduledMessage(message: ScheduledMessage) {
        self.scheduledMessages?.append(message)
        DataObserver.notifyScheduledMessages(messages: self.scheduledMessages!)
    }
    
    // we are ensuring the message list is cached and the latest message's timestamp matches
    // that of the conversation that is cached. Pulse does it's best to persist message lists
    // but it updates the conversation list much more often.
    func hasMessages(conversationId: Int64) -> Bool {
        if let messageList = messages[conversationId] {
            if let latestMessage = messageList.first {
                if let conversation = conversations?.first(where: { (conversation) -> Bool in return conversation.id == conversationId }) {
                    return latestMessage.timestamp >= conversation.timestamp - 1000
                }
            }
        }
        
        return false
    }
    
    // this is called from within the app, when opening an unread conversation
    func readConversation(conversationId: Int64) {
        if conversations == nil {
            return
        }
        
        for i in 0..<conversations!.count {
            if (conversations![i].id == conversationId) {
                let conversation = conversations![i]
                if (!conversation.read) {
                    conversations![i].read = true
                    DataObserver.notifyConversations(conversations: conversations!)
                    
                    PulseApi.conversations().read(conversation: conversation)
                    PulseApi.accounts().dismissNotification(conversation: conversation)
                }
                
                break
            }
        }
    }
    
    // this is called from the FCM receiver to update the read status of a conversation
    func markAsRead(conversationId: Int64) {
        if conversations == nil {
            return
        }
        
        for i in 0..<conversations!.count {
            if (conversations![i].id == conversationId) {
                conversations![i].read = true
                DataObserver.notifyConversations(conversations: conversations!)
                break
            }
        }
    }
    
    func generateId() -> Int64 {
        var rnd : Int64 = 0
        arc4random_buf(&rnd, MemoryLayout.size(ofValue: rnd))
        
        return rnd % 922337203685477
    }
}
