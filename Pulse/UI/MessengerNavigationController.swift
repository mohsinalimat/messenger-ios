//
//  BaseNavigationController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class MessengerNavigationController : UINavigationController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!Account.exists()) {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! LoginNavigationController
            self.present(secondViewController, animated: true)
        } else {
            DataProvider.loadContacts()
        }
    }
    
}
