//
//  KeyUtils.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import CryptoSwift

class KeyUtils {
    private let ITERATIONS = 10000
    private let KEY_LENGTH = 32
    
    func hashPassword(password: String, salt: String) throws -> String {
        do {
            let key = try PKCS5.PBKDF2(password: password.bytes, salt: salt.bytes, iterations: ITERATIONS, keyLength: KEY_LENGTH, variant: .sha1).calculate()
            return key.toBase64()!
        } catch {  }
        
        throw EncryptionError.failedCreatingKey
    }
    
    func createKey(passwordHash: String, accountId: String, salt: String) throws -> String {
        do {
            let combinedKey = "\(accountId):\(passwordHash)\n"
            let key = try PKCS5.PBKDF2(password: combinedKey.bytes, salt: salt.bytes, iterations: ITERATIONS, keyLength: KEY_LENGTH, variant: .sha1).calculate()
            return key.toBase64()!
        } catch {  }
        
        throw EncryptionError.failedCreatingKey
    }
}

enum EncryptionError: Error {
    case failedCreatingKey
}

