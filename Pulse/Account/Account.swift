//
//  Account.swift
//  Pulse
//
//  Created by Luke Klinker on 1/2/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation

let Account = _Account()

class _Account {
    var name: String?
    var phoneNumber: String?
    
    var accountId: String?
    var deviceId: String?
    
    private var salt: String?
    private var passwordHash: String?
    private var encryptionKey: String?
    
    var encryptionUtils: EncryptionUtils?
    
    init() {
        readValues()
    }
    
    func exists() -> Bool {
        return accountId != nil
    }
    
    func createAccount(password: String, loginResponse: LoginResponse) throws {
        let preferences = UserDefaults.standard
        
        preferences.set(loginResponse.name, forKey: AccountPreferenceKeys.NAME)
        preferences.set(loginResponse.number, forKey: AccountPreferenceKeys.PHONE_NUMBER)
        
        preferences.set(loginResponse.accountId, forKey: AccountPreferenceKeys.ACCOUNT_ID)
        
        let passwordHash = try KeyUtils().hashPassword(password: password, salt: loginResponse.salt2)
        let encryptionKey = try KeyUtils().createKey(passwordHash: passwordHash, accountId: loginResponse.accountId, salt: loginResponse.salt1)
        
        preferences.set(loginResponse.salt1, forKey: AccountPreferenceKeys.SALT)
        preferences.set(passwordHash, forKey: AccountPreferenceKeys.PASSWORD_HASH)
        preferences.set(encryptionKey, forKey: AccountPreferenceKeys.ENCRYPTION_KEY)
        
        preferences.synchronize()
        readValues()
    }
    
    private func readValues() {
        self.name = _Account.getKey(key: AccountPreferenceKeys.NAME)
        self.phoneNumber = _Account.getKey(key: AccountPreferenceKeys.PHONE_NUMBER)
        self.accountId = _Account.getKey(key: AccountPreferenceKeys.ACCOUNT_ID)
        self.deviceId = _Account.getKey(key: AccountPreferenceKeys.DEVICE_ID)
        self.salt = _Account.getKey(key: AccountPreferenceKeys.SALT)
        self.passwordHash = _Account.getKey(key: AccountPreferenceKeys.PASSWORD_HASH)
        self.encryptionKey = _Account.getKey(key: AccountPreferenceKeys.ENCRYPTION_KEY)
        
        if (encryptionKey != nil) {
            self.encryptionUtils = EncryptionUtils(key: self.encryptionKey!)
        }
    }
    
    private static func getKey(key: String) -> String? {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: key) == nil {
            return nil
        } else {
            return preferences.string(forKey: key)
        }
    }
}

private class AccountPreferenceKeys {
    static let NAME = "account_name"
    static let PHONE_NUMBER = "account_phone_number"
    static let ACCOUNT_ID = "account_id"
    static let DEVICE_ID = "account_device_id"
    static let PASSWORD_HASH = "account_password_hash"
    static let SALT = "account_salt"
    static let ENCRYPTION_KEY = "account_encryption_key"
}
