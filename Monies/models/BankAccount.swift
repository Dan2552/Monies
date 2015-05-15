//
//  BankAccount.swift
//  Monies
//
//  Created by Tim Preuß on 14.05.15.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

class BankAccount: RLMObject {
    dynamic var name = ""
    dynamic var sortCode = ""
    dynamic var accountNumber = ""
    dynamic var url = ""
    dynamic var balance = ""
    dynamic var available = ""
    dynamic var overdraft = ""
    dynamic var updatedAt = ""
    
    
    // All of these formatter methods shouldn't really be here in the model
    
    func doubleFromString(string: NSString) -> Double {
        let replaced = string.stringByReplacingOccurrencesOfString(",", withString: "")
        return (replaced as NSString).doubleValue
    }
    
    func updatedAtDate() -> NSDate {
        let interval = (updatedAt as NSString).doubleValue
        return NSDate(timeIntervalSince1970: interval)
    }
    
    func calculateRealAvailable() -> String {
        let a = doubleFromString(available)
        let b = doubleFromString(overdraft)
        let c = a - b
        return formatAsPrice(c)
    }
    
    func formatAsPrice(value: Double) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let price = formatter.stringFromNumber(value)!
        return price.stringByReplacingOccurrencesOfString("$", withString: "£")
    }
}
