//
//  InterfaceController.swift
//  Monies WatchKit Extension
//
//  Created by Daniel Green on 03/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WatchKit
import Foundation
import WebKit

class InterfaceController: WKInterfaceController, HalifaxDriverDelegate {

    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    var halifax: HalifaxDriver?
    
//    override func awakeWithContext(context: AnyObject?) {
//        super.awakeWithContext(context)
//        provisionRealm()
//    }
//    
//    func loadTable() {
//        let objects = HalifaxAccount.allObjects()
//        table.setNumberOfRows(Int(objects.count), withRowType: "row")
//        for (index, account) in objects.enumerate() {
//            let row = self.table.rowControllerAtIndex(index) as! TableRowController
//            row.setContentForAccount(account as! HalifaxAccount)
//        }
//    }
//
//    @IBAction func refreshButton() {
//        if halifax == nil {
//            halifax = HalifaxDriver(webView: WKWebView())
//            halifax?.halifaxDelegate = self
//        }
//        halifax?.loadAccounts()
//    }
//    
//    override func willActivate() {
//        super.willActivate()
//        loadTable()
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
//    }
//    
    func halifaxDriverAccountAdded(account: HalifaxAccount) {
//        loadTable()
    }
    
    func halifaxDriverLoadedPage(page: String) {
        self.label.setText(page)
    }

}
