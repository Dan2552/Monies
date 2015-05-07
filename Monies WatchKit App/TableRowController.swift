//
//  TableRowController.swift
//  Monies
//
//  Created by Daniel Green on 03/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WatchKit

class TableRowController: NSObject {
    @IBOutlet weak var available: WKInterfaceLabel!
    @IBOutlet weak var accountName: WKInterfaceLabel?
    @IBOutlet weak var agoLabel: WKInterfaceLabel?
    var updatedAt = NSDate()
    
    func setContentForAccount(account: [String : String]) {
        accountName?.setText(account["name"]?.componentsSeparatedByString(" ").first)
        available.setText(account["realAvailable"])
        let updatedAtString = account["updatedAt"]
        if let s = updatedAtString { updatedAt = updatedAtDate(s) }
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        if self.agoLabel != nil {
            self.agoLabel!.setText(self.updatedAt.timeAgoSinceNow())
            Async.main(after: 1) { self.updateTimeAgo() }
        }
    }
    
    func updatedAtDate(updatedAt: NSString) -> NSDate {
        let interval = updatedAt.doubleValue
        return NSDate(timeIntervalSince1970: interval)
    }
}
