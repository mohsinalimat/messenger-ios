//
//  BaseNavigationController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit

class ConversationNavigationController: UINavigationController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!Account.exists()) {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as! LoginNavigationController
            self.present(secondViewController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
