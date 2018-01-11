//
//  ComposeViewController.swift
//  Pulse
//
//  Created by Luke Klinker on 1/10/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import TURecipientBar

class ComposeViewController : UIViewController, TURecipientsBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipientsBar: ComposeRecipientBar!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyboardSize: NSLayoutConstraint!
    
    private var contacts = [Contact]()
    private var offsetY:CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.recipientsBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.recipientsBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.recipientsBar.recipientsBarDelegate = self
        self.recipientsBar.showsAddButton = false
        
        self.tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = self.contacts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        cell.bind(contact: contact)
        return cell
    }
    
    
    func recipientsBar(_ recipientsBar: TURecipientsBar, textDidChange searchText: String?) {
        let search = searchText?.lowercased() ?? ""
        self.contacts = DataProvider.contacts.filter { $0.name.lowercased().contains(search) || $0.phoneNumber.contains(search) }
        self.tableView.reloadData()
    }
    
    func recipientsBar(_ recipientsBar: TURecipientsBar, didAdd recipient: TURecipientProtocol) {
        recipientsBar.text = ""
    }
    
    func recipientsBar(_ recipientsBar: TURecipientsBar, didRemove recipient: TURecipientProtocol) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let contact = self.contacts[indexPath.row]
        if self.recipientsBar.containsContact(contact: contact) {
            self.recipientsBar.removeContact(contact: contact)
        } else {
            self.recipientsBar.addContact(contact: contact)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        let phoneNumbers = self.recipientsBar.contacts
            .map { $0.phoneNumber }
            .joined(separator: ",")
        
        PulseApi.messages().forwardToPhone(phoneNumbers: phoneNumbers, message: messageText.text!)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as?     NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardSize.constant = 0.0
            } else {
                self.keyboardSize.constant = (endFrame?.size.height ?? 0.0) - 20.0
            }
            
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve,
                  animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
}
