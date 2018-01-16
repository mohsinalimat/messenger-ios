//
//  DevicesRoute.swift
//  Pulse
//
//  Created by Luke Klinker on 1/11/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire
import DeviceKit
import SwiftyJSON

class DevicesRoute : BaseRoute {
    
    init() {
        super.init(route: "devices")
    }
    
    func add(accountId: String?, fcmToken: String?, completionHandler: @escaping (String) -> Void) {
        if accountId == nil || fcmToken == nil {
            return
        }
        
        let deviceType = Device().description
        
        post(path: "/add", parameters: ["account_id": accountId!, "device": ["info": "Apple, \(deviceType)", "name": deviceType, "primary": false, "fcm_token": fcmToken!, "ios": true]])
            .responseString { response in
                if let json = response.result.value, let dataFromString = json.data(using: .utf8, allowLossyConversion: false) {
                    do {
                        let jsonObject = try JSON(data: dataFromString)
                        let deviceId = jsonObject["id"].stringValue
                        completionHandler(deviceId)
                    } catch { }
                }
        }
    }
    
    func updateFcmToken(fcmToken: String) {
        if !Account.exists() {
            return
        }
        
        post(path: "/update/\(Account.deviceId!)", parameters: ["account_id": Account.accountId!, "fcm_token": fcmToken])
    }
}
