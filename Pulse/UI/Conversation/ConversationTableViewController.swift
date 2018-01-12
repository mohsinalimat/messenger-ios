//
//  ConversationTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import RxSwift

class ConversationTableViewController : UITableViewController {
    
    let refresh = UIRefreshControl()
    var sections = [ConversationSection]()
    var subscription: Disposable? = nil
    
    var actionGenerator: ConversationSwipeActionGenerator? = nil
    var sectionGenerator: SectionViewGenerator? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem = UITabBarItem(title: "Inbox", image: UIImage(named: "icon-conversations"), tag: 1)
        
        self.actionGenerator = ConversationSwipeActionGenerator(controller: self)
        self.sectionGenerator = SectionViewGenerator(controller: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
        self.tableView.refreshControl = refresh
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MessageTableViewController
        controller.conversation = conversation(indexPath: self.tableView.indexPathForSelectedRow!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].conversationCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].conversationCount() > 0 {
            return SectionViewGenerator.SECTION_HEADER_HEIGHT
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionGenerator?.generateSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = self.conversation(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as? ConversationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ConversationTableViewCell.")
        }

        cell.bind(conversation: conversation)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let conversation = self.conversation(indexPath: indexPath)
        let first = firstSwipeAction()
        let delete = actionGenerator!.delete()
        
        first.backgroundColor = UIColor(rgb: conversation.color)
        delete.backgroundColor = UIColor(rgb: conversation.colorDark)
        
        return [first, delete]
    }
    
    // MARK: Helper functions
    
    @objc private func reloadData(_ sender: Any) {
        reloadData()
    }
    
    func loadData() {
        subscription = DataObserver.conversations { conversations in
            self.sections = ConversationSection.loadConversationsToSections(conversations: conversations)
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        DataProvider.loadConversations()
    }
    
    func reloadData() {
        DataProvider.clear()
        DataProvider.loadConversations()
    }
    
    func firstSwipeAction() -> UITableViewRowAction {
        return actionGenerator!.archive()
    }
    
    func conversation(indexPath: IndexPath) -> Conversation {
        return self.sections[indexPath.section].conversations[indexPath.row]
    }
}
