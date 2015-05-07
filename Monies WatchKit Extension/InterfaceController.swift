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
    
    var objects = [[String : String]]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    func loadTable() {
        table.setNumberOfRows(objects.count, withRowType: "row")
        for (index, object) in enumerate(objects) {
            let row = self.table.rowControllerAtIndex(index) as! TableRowController
            row.setContentForAccount(object)
        }
    }

    @IBAction func refreshButton() {
        callToParent("refresh")
    }
    
    func callToParent(action: String) {
        self.label.setText("connecting")
        
        Communications.callToParent(action) { response, objects in
            self.label.setText(response)
            if let o = objects { self.objects = o }
            self.loadTable()
        }
    }
    
    override func willActivate() {
        callToParent("current")
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
