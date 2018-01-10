//
//  ScheduledMessageSwipeActionGenerator.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ScheduledMessageSwipeActionGenerator {
    
    private let controller: ScheduledMessageTableViewController
    
    init(controller: ScheduledMessageTableViewController) {
        self.controller = controller
    }
    
    func delete() -> UITableViewRowAction {
        return UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let message = self.controller.messages[indexPath.row]
            PulseApi.scheduledMessages().delete(message: message)
            
            self.controller.messages.remove(at: indexPath.row)
            self.controller.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

