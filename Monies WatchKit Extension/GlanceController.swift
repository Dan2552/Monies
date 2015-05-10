//
//  GlanceController.swift
//  Monies WatchKit Extension
//
//  Created by Daniel Green on 03/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var timeAgoLabel: WKInterfaceLabel!
    @IBOutlet weak var availableLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        provisionRealm();
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let objects = HalifaxAccount.allObjects()
        if objects.count > 0 {
            let account = objects.firstObject() as! HalifaxAccount!
            setContentForAccount(account)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setContentForAccount(account: HalifaxAccount) {
        nameLabel.setText(account.name.componentsSeparatedByString(" ").first)
        availableLabel.setText(account.calculateRealAvailable())
        updateTimeAgo(account)
    }
    
    func updateTimeAgo(account: HalifaxAccount) {
        timeAgoLabel.setText(account.updatedAtDate().timeAgoSinceNow())
        Async.main(after: 1) { self.updateTimeAgo(account) }
    }
}
