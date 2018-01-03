//
//  DataProvider.swift
//  Pulse
//
//  Created by Luke Klinker on 1/3/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

let DataProvider = _DataProvider()

class _DataProvider {
    
    private var conversations: [Conversation]? = nil
    
    func conversations(completed: @escaping ([Conversation]) -> Void) {
        if (conversations != nil) {
            completed(conversations!)
        } else {
            PulseApi.unarchivedConversations { (response: DataResponse<[Conversation]>) in
                if let conversations = response.result.value {
                    self.conversations = conversations
                    completed(conversations)
                } else {
                    completed([Conversation]())
                }
            }
        }
    }
}
