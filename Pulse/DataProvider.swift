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
    private var messagesObservable = [Int64: PublishSubject<[Message]>]()

    func conversations(onNext: @escaping (Event<[Conversation]>) -> Void) -> Disposable {
        let subscription = self.conversationsObservable.subscribe(onNext)
        return subscription
    }
    
    func messages(conversation: Conversation, onNext: @escaping (Event<[Message]>) -> Void) -> Disposable {
        if let publisher = messagesObservable[conversation.id] {
            return publisher.subscribe(onNext)
        } else {
            let publisher = PublishSubject<[Message]>()
            messagesObservable.updateValue(publisher, forKey: conversation.id)
            
            return publisher.subscribe(onNext)
        }
    }
    
    fileprivate func notifyConversations(conversations: [Conversation]) {
        conversationsObservable.onNext(conversations)
    }
    
    fileprivate func notifyMessages(conversation: Conversation, messages: [Message]) {
        if let publisher = messagesObservable[conversation.id] {
            publisher.onNext(messages)
        }
    }
}

class _DataProvider {
    
    private var conversations: [Conversation]? = nil
    private var messages = [Int64: [Message]]()
    
    func clear() {
        conversations = nil
    }
    
    func clearMessages(conversation: Conversation) {
        messages[conversation.id] = nil
    }
    
    func loadConversations() {
        if (conversations != nil) {
            DataObserver.notifyConversations(conversations: conversations!)
        } else {
            PulseApi.conversations().getUnarchived { (response: DataResponse<[Conversation]>) in
                if let conversations = response.result.value {
                    self.conversations = conversations
                    DataObserver.notifyConversations(conversations: conversations)
                } else {
                    DataObserver.notifyConversations(conversations: [Conversation]())
                }
            }
        }
    }
    
    func loadMessages(conversation: Conversation) {
        if hasMessages(conversation: conversation) {
            DataObserver.notifyMessages(conversation: conversation, messages: messages[conversation.id]!)
        } else {
            PulseApi.messages().getMessages(conversationId: conversation.id) { (response: DataResponse<[Message]>) in
                if let messageList = response.result.value {
                    self.messages.updateValue(messageList, forKey: conversation.id)
                    DataObserver.notifyMessages(conversation: conversation, messages: messageList)
                } else {
                    DataObserver.notifyMessages(conversation: conversation, messages: [Message]())
                }
            }
        }
    }
    
    // we are ensuring the message list is cached and the latest message's timestamp matches
    // that of the conversation that is cached. Pulse does it's best to persist message lists
    // but it updates the conversation list much more often.
    func hasMessages(conversation: Conversation) -> Bool {
        if let messageList = messages[conversation.id] {
            if let latestMessage = messageList.first {
                return latestMessage.timestamp >= conversation.timestamp - 1000
            }
        }
        
        return false
    }
}
