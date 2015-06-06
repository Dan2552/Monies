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
    var reloadTimer: NSTimer?
    var updatedTimeAgoTimer: NSTimer?
    var account: HSBCAccount?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        provisionRealm();
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadData()
        reloadTimer = NSTimer.scheduledTimerWithTimeInterval(30,
            target: self,
            selector: Selector("loadData"),
            userInfo: nil,
            repeats: true
        )
        updatedTimeAgoTimer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: Selector("updateTimeAgo"),
            userInfo: nil,
            repeats: true
        )
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        reloadTimer?.invalidate()
        updatedTimeAgoTimer?.invalidate()
    }
    
    func loadData() {
        let objects = HSBCAccount.allObjects()
        if objects.count > 0 {
            let account = objects.firstObject() as! HSBCAccount!
            setContentForAccount(account)
        }
    }
    
    func setContentForAccount(account: HSBCAccount) {
        self.account = account
        nameLabel.setText(account.name)
        availableLabel.setText(account.calculateRealAvailable())
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        if let a = account {
            timeAgoLabel.setText(a.updatedAtDate().timeAgoSinceNow())
        }
    }
}
