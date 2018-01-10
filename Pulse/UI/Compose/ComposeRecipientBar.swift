//
//  ComposeRecipientBar.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import TURecipientBar

class ComposeRecipientBar : TURecipientsBar {
    
    var contacts : [Contact] {
        return contactRecipients.map { $0.contact }
    }
    
    var contactRecipients : [ContactRecipient] {
        var array = [ContactRecipient]()
        for recipient in self.recipients {
            if let contact = recipient as? ContactRecipient {
                array.append(contact)
            }
        }
        
        return array
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addContact(contact: Contact){
        if containsContact(contact: contact) {
            return
        }
        
        addRecipient(ContactRecipient(contact: contact))
    }
    
    func removeContact(contact: Contact){
        removeByContactId(contactId: contact.id)
    }
    
    func removeByContactId(contactId: Int64){
        guard let foundRecipient = contactRecipients.filter({ $0.contact.id == contactId }).first else { return }
        removeRecipient(foundRecipient)
    }
    
    func containsContact(contact: Contact) -> Bool {
        return contactRecipients.contains(where: { $0.contact.id == contact.id })
    }
    
}

class ContactRecipient : NSObject, NSCopying, TURecipientProtocol {
    
    let contact: Contact
    init(contact: Contact) {
        self.contact = contact
        super.init()
    }
    
    public var recipientTitle: String {
        return contact.name
    }
    
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return ContactRecipient(contact: self.contact)
    }
}
