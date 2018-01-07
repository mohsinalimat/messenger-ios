//
//  ViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 12/31/17.
//  Copyright © 2017 Luke Klinker. All rights reserved.
//

import UIKit
import Alamofire
import Async

class LoginViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login(0)
        return true
    }

    @IBAction func login(_ sender: Any) {
        if (email.text != nil && email.text!.count != 0 && password.text != nil && password.text!.count != 0) {
            self.login.isEnabled = false
            self.password.resignFirstResponder()
            
            let email = self.email.text!
            let password = self.password.text!
            
            PulseApi.accounts().login(email: email, password: password) { (response: DataResponse<LoginResponse>) in
                if let loginResponse = response.result.value {
                    self.createAccount(loginResponse: loginResponse, password: self.password.text!)
                }
            }
        }
    }
    
    private func createAccount(loginResponse: LoginResponse, password: String) {
        Async.background {
            do {
                debugPrint("creating account encryption.")
                try Account.createAccount(password: password, loginResponse: loginResponse)
            } catch {
                debugPrint("error creating encryption for account.")
            }
        }.main {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessengerNavigationController") as! MessengerNavigationController
            self.present(secondViewController, animated: true)
        }
    }
}

