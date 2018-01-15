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
    var fcmToken: String?
    
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
    
    func createAccount(password: String, accountId: String, name: String, number: String, salt1: String, salt2: String) throws {
        let preferences = UserDefaults.standard
        
        preferences.set(name, forKey: AccountPreferenceKeys.NAME)
        preferences.set(number, forKey: AccountPreferenceKeys.PHONE_NUMBER)
        
        preferences.set(accountId, forKey: AccountPreferenceKeys.ACCOUNT_ID)
        
        let passwordHash = try KeyUtils().hashPassword(password: password, salt: salt2)
        let encryptionKey = try KeyUtils().createKey(passwordHash: passwordHash, accountId: accountId, salt: salt1)
        
        preferences.set(salt1, forKey: AccountPreferenceKeys.SALT)
        preferences.set(passwordHash, forKey: AccountPreferenceKeys.PASSWORD_HASH)
        preferences.set(encryptionKey, forKey: AccountPreferenceKeys.ENCRYPTION_KEY)
        
        preferences.synchronize()
        readValues()
    }
    
    func updateDeviceId(id: String) {
        self.deviceId = id
        let preferences = UserDefaults.standard
        
        preferences.set(id, forKey: AccountPreferenceKeys.DEVICE_ID)
        preferences.synchronize()
    }
    
    func updateFcmToken(token: String?) -> Bool {
        if token == nil || token == self.fcmToken {
            return false
        }
        
        self.fcmToken = token!
        let preferences = UserDefaults.standard
        
        preferences.set(token!, forKey: AccountPreferenceKeys.FCM_TOKEN)
        preferences.synchronize()
        
        return true
    }
    
    private func readValues() {
        self.name = _Account.getKey(key: AccountPreferenceKeys.NAME)
        self.phoneNumber = _Account.getKey(key: AccountPreferenceKeys.PHONE_NUMBER)
        self.accountId = _Account.getKey(key: AccountPreferenceKeys.ACCOUNT_ID)
        self.deviceId = _Account.getKey(key: AccountPreferenceKeys.DEVICE_ID)
        self.fcmToken = _Account.getKey(key: AccountPreferenceKeys.FCM_TOKEN)
        self.salt = _Account.getKey(key: AccountPreferenceKeys.SALT)
        self.passwordHash = _Account.getKey(key: AccountPreferenceKeys.PASSWORD_HASH)
        self.encryptionKey = _Account.getKey(key: AccountPreferenceKeys.ENCRYPTION_KEY)
        
        if encryptionKey != nil {
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
    static let FCM_TOKEN = "account_fcm_token"
    static let PASSWORD_HASH = "account_password_hash"
    static let SALT = "account_salt"
    static let ENCRYPTION_KEY = "account_encryption_key"
}
