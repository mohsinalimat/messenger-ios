//
//  MessageTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import RxSwift

class MessageTableViewController: UITableViewController {

    @IBOutlet weak var refresh: UIBarButtonItem!
    
    var messages = [Message]()
    var conversation: Conversation? = nil
    var subscription: Disposable? = nil // TODO: How should I dispose of this? (I just don't know the lifecycle well enough.)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = conversation?.title
        self.navigationController?.view.backgroundColor = UIColor.white
        
        self.tableView.register(UINib(nibName: "SentMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMessageTableViewCell")
        self.tableView.register(UINib(nibName: "ReceivedMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageTableViewCell")
        
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        subscription = DataObserver.messages(conversation: conversation!, onNext: { messages in
            self.messages = messages.reversed()
            self.showData()
        })
        
        if (!DataProvider.hasMessages(conversationId: conversation!.id)) {
            self.hideTableView()
        }
        
        AppOpenedUpdateHelper.currentlyOpenConversation = conversation!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        subscription?.dispose()
        AppOpenedUpdateHelper.currentlyOpenConversation = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (messages.count == 0) {
            DataProvider.loadMessages(conversation: conversation!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let identifier = CellIdentifier.get(message: message)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(identifier).")
        }
        
        cell.bind(conversation: conversation!, message: message)
        return cell
    }
    
    @IBAction func refreshData(_ sender: Any) {
        DataProvider.clearMessages(conversation: conversation!)
        
        hideTableView()
        DataProvider.loadMessages(conversation: conversation!)
    }
    
    private func showData() {
        self.tableView.reloadData()
        self.scrollToBottom()
        self.showTableView()
    }
    
    private func showTableView() {
        self.tableView.activityIndicatorView.stopAnimating()
        self.tableView.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    private func hideTableView() {
        self.tableView.activityIndicatorView.startAnimating()
        
        if (messages.count > 0) {
            self.tableView.alpha = 1.0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.alpha = 0.0
            })
        }
    }
    
    private func scrollToBottom() {
        if (self.messages.count > 0) {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
