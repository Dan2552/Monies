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

class InterfaceController: WKInterfaceController, BankDriverDelegate {

    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    var bankDriver: BankWebDriver?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        provisionRealm()
    }
    
    func loadTable() {
        let objects = HSBCAccount.allObjects()
        table.setNumberOfRows(Int(objects.count), withRowType: "row")
        for (index, account) in enumerate(objects) {
            let row = self.table.rowControllerAtIndex(index) as! TableRowController
            row.setContentForAccount(account as! HSBCAccount)
        }
    }

    @IBAction func refreshButton() {
        if bankDriver == nil {
            bankDriver = HSBCDriver(webView: WKWebView())
            bankDriver?.bankDelegate = self
        }
        bankDriver?.loadAccounts()
    }
    
    override func willActivate() {
        super.willActivate()
        loadTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func bankDriverDelegateAccountAdded(account: BankAccount) {
        loadTable()
    }
    
    func bankDriverDelegateLoadedPage(pageName: String, percent: Float) {
        self.label.setText(pageName)
    }

    func bankDriverDelegateRunning(running: Bool) {
        
    }

}
