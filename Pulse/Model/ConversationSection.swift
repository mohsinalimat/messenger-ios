//
//  SectionType.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

class ConversationSection {
    
    let type: SectionType
    var conversations = [Conversation]()
    
    init(type: SectionType) {
        self.type = type
    }
    
    func conversationCount() -> Int {
        return conversations.count
    }
    
    public static func loadConversationsToSections(conversations: [Conversation]) -> [ConversationSection] {
        let sections = [
            ConversationSection(type: .pinned), ConversationSection(type: .today), ConversationSection(type: .yesterday),
            ConversationSection(type: .lastWeek), ConversationSection(type: .lastMonth), ConversationSection(type: .older)
        ]
        
        for conversation in conversations {
            if conversation.pinned {
                sections[0].conversations.append(conversation)
            } else if (conversation.timestamp.isToday()) {
                sections[1].conversations.append(conversation)
            } else if (conversation.timestamp.isYesterday()) {
                sections[2].conversations.append(conversation)
            } else if (conversation.timestamp.isLastWeek()) {
                sections[3].conversations.append(conversation)
            } else if (conversation.timestamp.isLastMonth()) {
                sections[4].conversations.append(conversation)
            } else {
                sections[5].conversations.append(conversation)
            }
        }
        
        return sections
    }
}

enum SectionType {
    case pinned, today, yesterday, lastWeek, lastMonth, older
}
