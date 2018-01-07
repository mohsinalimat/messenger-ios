//
//  ConversationTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class ConversationTableViewController : UITableViewController {
    
    var actionGenerator: SwipeActionGenerator? = nil
    var sectionGenerator: SectionViewGenerator? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.actionGenerator = SwipeActionGenerator(controller: self)
        self.sectionGenerator = SectionViewGenerator(controller: self)
    }
    
    var sections = [ConversationSection]()
    var subscription: Disposable? = nil
    
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refresh
        } else {
            self.tableView.addSubview(refresh)
        }
        
        subscription = DataObserver.conversations { conversations in
            self.sections = ConversationSection.loadConversationsToSections(conversations: conversations)
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
        
        DataProvider.loadConversations()
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
        let delete = actionGenerator!.delete()
        let archive = actionGenerator!.archive()
        
        archive.backgroundColor = UIColor(rgb: conversation.color)
        delete.backgroundColor = UIColor(rgb: conversation.colorDark)
        
        return [archive, delete]
    }
    
    // MARK: Helper functions
    
    @objc private func loadData(_ sender: Any) {
        DataProvider.clear()
        DataProvider.loadConversations()
    }
    
    func conversation(indexPath: IndexPath) -> Conversation {
        return self.sections[indexPath.section].conversations[indexPath.row]
    }
}
