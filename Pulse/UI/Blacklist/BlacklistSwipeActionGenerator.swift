//
//  BlacklistSwipeActionGenerator.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class BlacklistSwipeActionGenerator {
    
    private let controller: BlacklistTableViewController
    
    init(controller: BlacklistTableViewController) {
        self.controller = controller
    }
    
    func delete() -> UITableViewRowAction {
        return UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let blacklist = self.controller.blacklists[indexPath.row]
            PulseApi.blacklists().delete(blacklist: blacklist)
            
            self.controller.blacklists.remove(at: indexPath.row)
            self.controller.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
