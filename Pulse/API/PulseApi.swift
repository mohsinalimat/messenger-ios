//
//  PulseApi.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

let PulseApi = _PulseApi()

class _PulseApi {
    private let BASE_URL = "https://api.messenger.klinkerapps.com/api/v1/"
    private let accountId = "***REMOVED***"
    
    private func get(path: String, parameters: Parameters) -> DataRequest {
        return Alamofire.request("\(BASE_URL)\(path)", method: .get, parameters: parameters)
    }
    
    private func post(path: String, parameters: Parameters) -> DataRequest {
        return Alamofire.request("\(BASE_URL)\(path)", method: .post, parameters: parameters)
    }
    
    func login(email: String, password: String, completionHandler: @escaping (DataResponse<LoginResponse>) -> Void) {
        post(path: "accounts/login", parameters: ["username": email, "password": password])
            .responseObject(completionHandler: completionHandler)
    }
    
    func conversations(completionHandler: @escaping (DataResponse<[Conversation]>) -> Void) {
        get(path: "conversations", parameters: ["account_id": accountId, "limit": 10])
            .responseCollection(completionHandler: completionHandler)
    }
    
//    PulseApi.conversations() { (response: DataResponse<[Conversation]>) in
//    debugPrint(response)
//
//    if let conversations = response.result.value {
//    conversations.forEach { print("- \($0.description)") }
//    }
//    }
}
