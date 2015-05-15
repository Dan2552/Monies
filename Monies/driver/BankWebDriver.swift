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
    func bankDriverDelegateLoadedPage(page: String)
}

class BankWebDriver: WebViewDriver {
    var bankDelegate: BankDriverDelegate?
    
    func getAccounts() {
        
    }
    
    func loadAccounts() {
    }
}
