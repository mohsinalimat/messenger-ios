//
//  EncryptionUtils.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import CryptoSwift

class EncryptionUtils {
    
    private let SEPARATOR = "-:-";
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func decrypt(data: String) -> String? {
        let splitData = data.components(separatedBy: SEPARATOR)
        let dataOne = splitData[0].base64Decoded()
        let dataTwo = splitData[1].base64Decoded()
        
        do {
            let aes = try AES(key: key.base64Decoded()!, blockMode: .CBC(iv: dataOne!), padding: .pkcs5)
            let bytes = try aes.decrypt(dataTwo!)
            return String(data: Data(bytes), encoding: .utf8)
        } catch is Error {
            debugPrint("Error decrypting.")
        }
        
        return nil
    }
    
    
}

extension String {
    func base64Decoded() -> [UInt8]? {
        let nsdata1 = Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return nsdata1?.withUnsafeBytes { Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1!.count/MemoryLayout<UInt8>.size)) }
    }
}
