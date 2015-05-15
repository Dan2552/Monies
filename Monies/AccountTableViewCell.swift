//
//  AccountTableViewCell.swift
//  Monies
//
//  Created by Daniel Green on 01/02/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    var updatedAt = NSDate()
    
    func setContentForAccount(account: BankAccount) {
        accountName.text = account.name
        available.text =  account.calculateRealAvailable()
        updatedAt = account.updatedAtDate()
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        self.timeAgoLabel.text = self.updatedAt.timeAgoSinceNow()
        Async.main(after: 1) { self.updateTimeAgo() }
    }
}

