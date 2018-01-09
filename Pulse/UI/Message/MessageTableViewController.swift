//
//  MessageTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import SlackTextViewController
import RxSwift
import Kingfisher

class MessageTableViewController : SLKTextViewController {

    @IBOutlet weak var refresh: UIBarButtonItem!
    
    var messages = [Message]()
    var conversation: Conversation? = nil
    var subscription: Disposable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = conversation?.title
        self.navigationController?.view.backgroundColor = UIColor.white
        
        self.tableView!.allowsSelection = false
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.separatorStyle = .none
        self.tableView!.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive;
        
        // Slack Text View Controller setup
        self.bounces = true
        self.shakeToClearEnabled = true
        self.isKeyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.isInverted = true
        self.rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState())
        self.textInputbar.autoHideRightButton = true
        self.textView.placeholder = "Type message...";
        self.textView.keyboardType = UIKeyboardType.default
        
        subscription = DataObserver.messages(conversation: conversation!, onNext: { messages in
            self.messages = messages
            self.showData()
        })
        
        if (!DataProvider.hasMessages(conversationId: conversation!.id)) {
            self.hideTableView()
        }
        
        ImageDownloader.default.delegate = Account.encryptionUtils
        CellIdentifier.registerCells(tableView: self.tableView!)
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
        
        DataProvider.markAsRead(conversationId: conversation!.id)
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
        
        cell.transform = self.tableView!.transform
        cell.bind(conversation: conversation!, message: message)
        return cell
    }
    
    override func didPressRightButton(_ sender: Any!) {
        self.textView.refreshFirstResponder()
        
        let message = PulseApi.messages().send(conversation: conversation!, message: self.textView.text, mimeType: MimeType.TEXT_PLAIN)
        let indexPath = IndexPath(row: 0, section: 0)
        let rowAnimation: UITableViewRowAnimation = self.isInverted ? .bottom : .top
        let scrollPosition: UITableViewScrollPosition = self.isInverted ? .bottom : .top
        
        self.tableView!.beginUpdates()
        self.messages.insert(message, at: 0)
        self.tableView!.insertRows(at: [indexPath], with: rowAnimation)
        self.tableView!.endUpdates()
        
        self.tableView!.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
        self.tableView!.reloadRows(at: [indexPath], with: .automatic)
        
        super.didPressRightButton(sender)
    }
    
    @IBAction func refreshData(_ sender: Any) {
        DataProvider.clearMessages(conversation: conversation!)
        
        hideTableView()
        DataProvider.loadMessages(conversation: conversation!)
    }
    
    private func showData() {
        self.tableView!.reloadData()
        self.showTableView()
    }
    
    private func showTableView() {
        self.activityIndicatorView.stopAnimating()
        self.tableView!.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView!.alpha = 1.0
        })
    }
    
    private func hideTableView() {
        self.activityIndicatorView.startAnimating()
        
        if (messages.count > 0) {
            self.tableView!.alpha = 1.0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView!.alpha = 0.0
            })
        }
    }
}
