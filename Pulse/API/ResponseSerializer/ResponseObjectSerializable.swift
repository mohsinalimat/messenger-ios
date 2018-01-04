//
//  ResponseObjectSerializable.swift
//  Pulse
//
//  Created by Luke Klinker on 1/1/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}
