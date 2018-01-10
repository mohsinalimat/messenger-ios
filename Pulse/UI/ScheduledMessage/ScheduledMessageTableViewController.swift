//
//  ScheduledMessageTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ScheduledMessageTableViewController : UITableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Scheduled", image: UIImage(named: "icon-scheduled-messages"), tag: 3)
    }
}
