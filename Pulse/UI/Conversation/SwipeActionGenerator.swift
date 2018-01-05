//
//  SwipeActionGenerator.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class SwipeActionGenerator {
    
    private let controller: ConversationTableViewController
    
    init(controller: ConversationTableViewController) {
        self.controller = controller
    }
    
    func delete() -> UITableViewRowAction {
        return UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let conversation = self.controller.conversation(indexPath: indexPath)
            PulseApi.conversations().delete(conversation: conversation)
            
            self.controller.sections[indexPath.section].conversations.remove(at: indexPath.row)
            self.controller.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func archive() -> UITableViewRowAction {
        return UITableViewRowAction(style: .default, title: "Archive") { (action, indexPath) in
            let conversation = self.controller.conversation(indexPath: indexPath)
            PulseApi.conversations().archive(conversation: conversation)
            
            self.controller.sections[indexPath.section].conversations.remove(at: indexPath.row)
            self.controller.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
