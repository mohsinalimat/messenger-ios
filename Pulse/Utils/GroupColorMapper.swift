//
//  GroupColorMapper.swift
//  Pulse
//
//  Created by Luke Klinker on 1/14/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

class GroupColorMapper {
    
    private let conversation: Conversation
    private var contactNamesToColors = [String: Int]()
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
    func buildMap() {
        conversation.phoneNumbers.components(separatedBy: ", ").forEach { number in
            let idMatcher = number.createIdMatcher()
            debugPrint("\(idMatcher). contacts size: \(DataProvider.contacts.count)")
            for contact in DataProvider.contacts {
                if contact.idMatcher == idMatcher {
                    debugPrint("matched \(contact.name) to color")
                    contactNamesToColors.updateValue(contact.color, forKey: contact.name)
                    break
                }
            }
        }
    }
    
    func getColor(contactName: String) -> Int {
        if let color = contactNamesToColors[contactName] {
            return color
        } else {
            return conversation.color
        }
    }
}

fileprivate extension String {
    func createIdMatcher() -> String {
        let stripped = self.replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ",", with: "")
        
        if (stripped.count > 8) {
            return stripped.suffix(8).description
        } else {
            return stripped
        }
    }
}
