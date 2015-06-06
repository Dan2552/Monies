//
//  LoginCredentials.swift
//  Monies
//
//  Created by Tim Preuß on 06.06.15.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import UIKit
import SSKeychain

enum BankType : Int {
    case Unknown = 0
    case Halifax = 1
    case HSBC = 2
}

class LoginCredentials {
    static let sharedInstance = LoginCredentials()
    
    var bankType: BankType?
    var username: String?
    var memorableAnswer: String?
    var password: String?
    
    init() {
        if let username = sharedUserDefaults().stringForKey("loginName") {
            self.username = username as String
            
            self.bankType = BankType(rawValue: sharedUserDefaults().integerForKey("bankType"))!
        
            self.memorableAnswer = SSKeychain.passwordForService(username, account: "memorableAnswer")
            self.password = SSKeychain.passwordForService(username, account: "password")
        } else {
            self.username = nil
            self.bankType = .Unknown
            self.memorableAnswer = nil
            self.password = nil
        }
    }
    
    func sharedUserDefaults() -> NSUserDefaults {
        return NSUserDefaults(suiteName: "group.wildcard")!
    }
    
    func credentialsPresent() -> Bool {
        return (self.username != nil && self.bankType != .Unknown && self.memorableAnswer != nil && self.password != nil)
    }
    
    func saveCredentials() {
        sharedUserDefaults().setValue(self.username, forKey: "loginName")
        sharedUserDefaults().setValue(self.bankType?.rawValue, forKey: "bankType")
        sharedUserDefaults().synchronize()
        
        SSKeychain.setPassword(self.memorableAnswer, forService: self.username, account: "memorableAnswer")
        SSKeychain.setPassword(self.password, forService: self.username, account: "password")
    }
}