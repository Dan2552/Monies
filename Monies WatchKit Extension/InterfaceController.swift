//
//  InterfaceController.swift
//  Monies WatchKit Extension
//
//  Created by Daniel Green on 03/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        provisionRealm()
    }
    
    func loadTable() {
        let objects = HalifaxAccount.allObjects()
        table.setNumberOfRows(Int(objects.count), withRowType: "row")
        for (index, account) in enumerate(objects) {
            let row = self.table.rowControllerAtIndex(index) as! TableRowController
            row.setContentForAccount(account as! HalifaxAccount)
        }
    }

    @IBAction func refreshButton() {
        callToParent("refresh")
    }
    
    func callToParent(action: String) {
        self.label.setText("connecting")
        
        Communications.callToParent(action) { response in
            self.label.setText(response)
            self.loadTable()
        }
    }
    
    override func willActivate() {
        super.willActivate()
        loadTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
