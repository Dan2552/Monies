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
    var objects = [[String : String]]()
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        provisionRealm();
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        loadTable()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    func loadTable() {
        let objects = HalifaxAccount.allObjects()
        table.setNumberOfRows(Int(objects.count), withRowType: "row")
        for (index, account) in enumerate(objects) {
            let row = self.table.rowControllerAtIndex(index) as! TableRowController
            row.setContentForAccount(account as! HalifaxAccount)
        }
    }
    
    func callToParent(action: String) {
        Communications.callToParent(action) { response in
            self.loadTable()
        }
    }

}
