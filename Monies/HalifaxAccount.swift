//
//  HalifaxAccount.swift
//  MoniesMac
//
//  Created by Daniel Green on 28/01/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

class HalifaxAccount: RLMObject {
    dynamic var name = ""
    dynamic var sortCode = ""
    dynamic var accountNumber = ""
    dynamic var url = ""
    dynamic var balance = ""
    dynamic var available = ""
    dynamic var overdraft = ""
    dynamic var updatedAt = ""
    
    func setFromDetails(heading: String, details: String, url: String) {
        self.url = url
        
        let headingSplit = heading.componentsSeparatedByString("\n")
        name = headingSplit[0]
        let headingSplit2 = headingSplit[1].componentsSeparatedByString(",")
        sortCode = headingSplit2[0]
        accountNumber = headingSplit2[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let rows = details.componentsSeparatedByString("\n") as [String]
        for row in rows {
            let value = row.componentsSeparatedByString("£").last
            if row.hasPrefix("Balance") {
                balance = value!
            } else if row.hasPrefix("Money available") {
                available = value!
            } else if row.hasPrefix("Overdraft") {
                overdraft = value!
            }
        }
        updatedAt = "\(NSDate().timeIntervalSince1970)"
    }
    
    
    
    
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
