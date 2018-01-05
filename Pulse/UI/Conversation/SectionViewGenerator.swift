//
//  SectionViewGenerator.swift
//  Pulse
//
//  Created by Luke Klinker on 1/5/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class SectionViewGenerator {
    
    static let SECTION_HEADER_HEIGHT: CGFloat = 32
    
    private let controller: ConversationTableViewController
    
    init(controller: ConversationTableViewController) {
        self.controller = controller
    }
    
    func generateSection(section: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.controller.tableView.bounds.width, height: SectionViewGenerator.SECTION_HEADER_HEIGHT))
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.controller.tableView.bounds.width - 30, height: SectionViewGenerator.SECTION_HEADER_HEIGHT))
        
        label.text = getTitle(type: self.controller.sections[section].type)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.black
        
        view.addSubview(label)
        return view
    }
    
    private func getTitle(type: SectionType) -> String {
        switch type {
            case .pinned:
                return "Pinned"
            case .today:
                return "Today"
            case .yesterday:
                return "Yesterday"
            case .lastWeek:
                return "This Week"
            case .lastMonth:
                return "This Month"
            default:
                return "Older"
        }
    }
}
