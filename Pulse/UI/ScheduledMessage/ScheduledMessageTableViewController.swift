//
//  ScheduledMessageTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import RxSwift

class ScheduledMessageTableViewController : UITableViewController {
    
    let refresh = UIRefreshControl()
    var messages = [ScheduledMessage]()
    var subscription: Disposable? = nil
    
    var actionGenerator: ScheduledMessageSwipeActionGenerator? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Scheduled", image: UIImage(named: "icon-scheduled-messages"), tag: 3)
        self.actionGenerator = ScheduledMessageSwipeActionGenerator(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ScheduledMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduledMessageTableViewCell")
        
        self.refresh.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
        self.tableView.refreshControl = refresh
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledMessageTableViewCell", for: indexPath) as? ScheduledMessageTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduledMessageTableViewCell.")
        }
        
        cell.bind(message: message)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [actionGenerator!.delete()]
    }
    
    // MARK: Helper functions
    
    @objc private func reloadData(_ sender: Any) {
        reloadData()
    }
    
    func loadData() {
        subscription = DataObserver.scheduledMessages { messages in
            self.messages = messages
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        DataProvider.loadScheduledMessages()
    }
    
    func reloadData() {
        DataProvider.clear()
        DataProvider.loadScheduledMessages()
    }
}
