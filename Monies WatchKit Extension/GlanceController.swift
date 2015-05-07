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
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        callToParent("current")
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    func loadTable() {
        table.setNumberOfRows(objects.count, withRowType: "row")
        for (index, object) in enumerate(objects) {
            let row = self.table.rowControllerAtIndex(index) as! TableRowController
            row.setContentForAccount(object)
        }
    }
    func callToParent(action: String) {
        Communications.callToParent(action) { response, objects in
            if let o = objects { self.objects = o }
            self.loadTable()
        }
    }

}
