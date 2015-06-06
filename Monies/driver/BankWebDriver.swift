//
//  BankWebDriver.swift
//  Monies
//
//  Created by Tim Preuß on 14.05.15.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import UIKit

protocol BankDriverDelegate {
    func bankDriverDelegateAccountAdded(account: BankAccount)
    func bankDriverDelegateLoadedPage(pageName: String, percent: Float)
    func bankDriverDelegateRunning(running: Bool)
}

class BankWebDriver: WebViewDriver {
    var bankDelegate: BankDriverDelegate?
    var drive = true
    var loadAccountsInProgress = false
    
    func getAccounts() {
        
    }
    
    func loadAccounts() {
    }
}
