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
    var subscription: Disposable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationItem.title = conversation?.title
        
        self.tableView.register(UINib(nibName: "SentMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMessageTableViewCell")
        self.tableView.register(UINib(nibName: "ReceivedMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageTableViewCell")
        
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 56
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        subscription = DataObserver.messages(conversation: conversation!, onNext: { messages in
            self.messages = messages.element!.reversed()
            self.showData()
        })
        
        if (!DataProvider.hasMessages(conversation: conversation!)) {
            self.hideTableView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (messages.count == 0) {
            loadData()
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        DataProvider.clearMessages(conversation: conversation!)
        
        hideTableView()
        loadData()
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // MARK: Table view UI functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let identifier = getCellIdentifier(message: message)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(identifier).")
        }
        
        cell.bind(conversation: conversation!, message: message)
        return cell
    }
    
    // MARK: helper functions
    
    private func loadData() {
        DataProvider.loadMessages(conversation: conversation!)
    }
    
    private func showData() {
        self.tableView.reloadData()
        self.scrollToBottom()
        self.showTableView()
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
    
    private func showTableView() {
        self.tableView.activityIndicatorView.stopAnimating()
        self.tableView.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    private func scrollToBottom() {
        if (self.messages.count > 0) {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    private func getCellIdentifier(message: Message) -> String {
        if (message.messageType == MessageType.RECEIVED) {
            return "ReceivedMessageTableViewCell"
        } else {
            // TODO: handle media/info and error/sending/sent/delivered status
            return "SentMessageTableViewCell"
        }
    }
}
