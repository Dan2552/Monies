//
//  HSBCAccount.swift
//  Monies
//
//  Created by Tim Preuß on 14.05.15.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

class HSBCAccount: BankAccount {
    func setFromDetails(heading: String, details: String, url: String) {
        self.url = url
        self.name = heading;
        
        let newBalance = details.stringByReplacingOccurrencesOfString("C", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        println(newBalance)
        self.balance = newBalance

        
        /*let headingSplit = heading.componentsSeparatedByString("\n")
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
        }*/
        updatedAt = "\(NSDate().timeIntervalSince1970)"
    }
}
