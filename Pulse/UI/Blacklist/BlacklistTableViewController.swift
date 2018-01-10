//
//  BlacklistTableViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class BlacklistTableViewController : UITableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Blacklists", image: UIImage(named: "icon-blacklists"), tag: 4)
    }
}
