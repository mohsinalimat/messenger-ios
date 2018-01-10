//
//  BlacklistTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import RxSwift

class BlacklistTableViewController : UITableViewController {
    
    let refresh = UIRefreshControl()
    var blacklists = [Blacklist]()
    var subscription: Disposable? = nil
    
    var actionGenerator: BlacklistSwipeActionGenerator? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBarItem = UITabBarItem(title: "Blacklist", image: UIImage(named: "icon-blacklists"), tag: 4)
        self.actionGenerator = BlacklistSwipeActionGenerator(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        refresh.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refresh
        } else {
            self.tableView.addSubview(refresh)
        }
        
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blacklists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blacklist = self.blacklists[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlacklistTableViewCell", for: indexPath) as? BlacklistTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BlacklistTableViewCell.")
        }
        
        cell.bind(blacklist: blacklist)
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
        subscription = DataObserver.blacklists{ blacklists in
            self.blacklists = blacklists
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        DataProvider.loadBlacklists()
    }
    
    func reloadData() {
        DataProvider.clear()
        DataProvider.loadBlacklists()
    }
}
