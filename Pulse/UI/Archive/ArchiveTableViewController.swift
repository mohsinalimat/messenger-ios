//
//  ArchiveTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ArchiveTableViewController : ConversationTableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Archive", image: UIImage(named: "icon-archive"), tag: 2)
    }
    
    override func loadData() {
        subscription = DataObserver.archive { conversations in
            self.sections = ConversationSection.loadConversationsToSections(conversations: conversations)
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        DataProvider.loadArchive()
    }
    
    override func reloadData() {
        DataProvider.clear()
        DataProvider.loadArchive()
    }
    
    override func firstSwipeAction() -> UITableViewRowAction {
        return actionGenerator!.moveToInbox()
    }
}
