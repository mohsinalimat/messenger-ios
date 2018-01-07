//
//  EncryptionUtils.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import CryptoSwift
import Kingfisher

//
// This is used both for encrypting and decrypting messages/conversations, as well as
// decrypting images that are downloaded from Kingfisher
//

class EncryptionUtils : ImageDownloaderDelegate {
    
    private let SEPARATOR = "-:-";
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func encrypt(data: String) -> String {
        return encryptData(data: data.bytes)
    }
    
    func encryptData(data: [UInt8]) -> String {
        do {
            let iv = AES.randomIV(AES.blockSize)
            let aes = try AES(key: key.base64Decoded()!, blockMode: .CBC(iv: iv), padding: .pkcs5)
            let ciphertext = try aes.encrypt(data)
            return "\(iv.toBase64()!)\(SEPARATOR)\(ciphertext.toBase64()!)"
        } catch {
            
        }
        
        return data.toBase64()!
    }
    
    func decrypt(data: String) -> String? {
        if let decrypted = decryptData(data: data) {
            return String(data: Data(decrypted), encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func decryptData(data: String) -> [UInt8]? {
        let splitData = data.components(separatedBy: SEPARATOR)
        let dataOne = splitData[0].base64Decoded()
        let dataTwo = splitData[1].base64Decoded()
        
        do {
            let aes = try AES(key: key.base64Decoded()!, blockMode: .CBC(iv: dataOne!), padding: .pkcs5)
            return try aes.decrypt(dataTwo!)
        } catch {
            debugPrint("Error decrypting.")
        }
        
        return nil
    }
    
    func imageDownloader(_ downloader: ImageDownloader, didDownload data: Data, for url: URL) -> Data? {
        if let dataString = String(data: data, encoding: .utf8), let decrypted = decryptData(data: dataString) {
            return Data(decrypted)
        }
        
        return data
    }
}

extension String {
    func base64Decoded() -> [UInt8]? {
        let nsdata1 = Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return nsdata1?.withUnsafeBytes { Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1!.count/MemoryLayout<UInt8>.size)) }
    }
}
