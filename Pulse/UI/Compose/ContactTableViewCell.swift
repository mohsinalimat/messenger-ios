//
//  ContactTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ContactTableViewCell : UITableViewCell {
    
    @IBOutlet weak var contact: UILabel!
    
    func bind(contact: Contact) {
        self.contact.text = "\(contact.name) (\(contact.phoneNumber))"
    }
}
