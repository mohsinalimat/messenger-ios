//
//  SectionType.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

class ConversationSectionType {
    
    let type: SectionType
    var conversations = [Conversation]()
    
    init(type: SectionType) {
        self.type = type
    }
    
    func conversationCount() -> Int {
        return conversations.count
    }
}

enum SectionType {
    case pinned, today, yesterday, lastWeek, lastMonth, older
}
