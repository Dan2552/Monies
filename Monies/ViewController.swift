//
//  ViewController.swift
//  Monies
//
//  Created by Daniel Green on 05/06/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, WebViewDriverProgressDelegate, BankDriverDelegate {

    let webDriver = HSBCDriver(webView: WKWebView())
    var accounts = BankAccount.allObjects()
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webDriver.delegate = self
        webDriver.bankDelegate = self
        self.view.addSubview(webDriver.webview)
        webDriver.webview.hidden = true
        webDriver.loadAccounts()
    }
    
    func webViewDriverProgress(progress: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = progress
    }
    
    func bankDriverDelegateAccountAdded(account: BankAccount) {
        refresh()
    }

    func bankDriverDelegateLoadedPage(page: String) {
        toggleWebButton.title = page
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    override func viewWillDisappear(animated: Bool) {
        webViewDriverProgress(false)
    }
    
    func refresh() {
        accounts = HSBCAccount.allObjects()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(accounts.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AccountTableViewCell
        let account = accounts.objectAtIndex(UInt(indexPath.row)) as! BankAccount
        cell.setContentForAccount(account)
        return cell
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        sizeWebView()
    }
    
    // Probably should use constraints here...
    func sizeWebView() {
        let top = self.tableView.contentInset.top
        let height = self.view.frame.height - top
        webDriver.webview.frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: height)
    }
    
    @IBOutlet var toggleWebButton : UIBarButtonItem!
    
    @IBAction func toggleWeb(sender : UIBarButtonItem) {
        if webDriver.webview.hidden {
            webDriver.webview.hidden = false
            tableView.hidden = true
            webDriver.drive = false
            sizeWebView()
        } else {
            webDriver.loadAccounts()
            webDriver.webview.hidden = true
            tableView.hidden = false
            webDriver.drive = true
        }
    }
}

