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
    
    func setContentForAccount(account: HSBCAccount) {
        accountName?.setText(account.name.componentsSeparatedByString(" ").first)
        available.setText(account.calculateRealAvailable())
        updatedAt = account.updatedAtDate()
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        if self.agoLabel != nil {
            self.agoLabel!.setText(self.updatedAt.timeAgoSinceNow())
            Async.main(after: 1) { self.updateTimeAgo() }
        }
    }
}
