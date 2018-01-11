//
//  PulseApi.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

let PulseApi = _PulseApi()

class _PulseApi {
    
    func accounts() -> AccountsRoute {
        return AccountsRoute()
    }
    
    func devices() -> DevicesRoute {
        return DevicesRoute()
    }
    
    func conversations() -> ConversationsRoute {
        return ConversationsRoute()
    }
    
    func messages() -> MessagesRoute {
        return MessagesRoute()
    }
    
    func scheduledMessages() -> ScheduledMessagesRoute {
        return ScheduledMessagesRoute()
    }
    
    func blacklists() -> BlacklistsRoute {
        return BlacklistsRoute()
    }
    
    func contacts() -> ContactsRoute {
        return ContactsRoute()
    }
}
