//
//  FcmHandler.swift
//  Pulse
//
//  Created by Luke Klinker on 1/11/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import SwiftyJSON

let FcmHandler = _FcmHandler()

class _FcmHandler {
    func handle(operation: String, json: JSON) {
        switch operation {
        case "added_message": addedMessage(json: json)
        default: debugPrint("no fcm handler for \(operation)")
        }
    }
    
    private func addedMessage(json: JSON) {
        
    }
}
