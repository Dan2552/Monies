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
    case Halixfax = 1
    case HSBC = 2
}

class LoginCredentials {
    static let sharedInstance = LoginCredentials()
    
    var bankType: BankType?
    var username: String?
    var memorableAnswer: String?
    var password: String?
    
    init() {
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("loginName") {
            self.username = username as String
            
            self.bankType = BankType(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("bankType"))!
        
            self.memorableAnswer = SSKeychain.passwordForService(username, account: "memorableAnswer")
            self.password = SSKeychain.passwordForService(username, account: "password")
        } else {
            self.username = nil
            self.bankType = .Unknown
            self.memorableAnswer = nil
            self.password = nil
        }
    }
    
    func credentialsPresent() -> Bool {
        return (self.username != nil && self.bankType != .Unknown && self.memorableAnswer != nil && self.password != nil)
    }
    
    func saveCredentials() {
        NSUserDefaults.standardUserDefaults().setValue(self.username, forKey: "loginName")
        NSUserDefaults.standardUserDefaults().setValue(self.bankType?.rawValue, forKey: "bankType")
        
        SSKeychain.setPassword(self.memorableAnswer, forService: self.username, account: "memorableAnswer")
        SSKeychain.setPassword(self.password, forService: self.username, account: "password")
    }
}
