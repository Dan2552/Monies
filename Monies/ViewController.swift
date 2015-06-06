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

    var webDriver: BankWebDriver?;
    var accounts = BankAccount.allObjects()
    
    @IBOutlet var toggleWebButton : UIBarButtonItem!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        performSegueWithIdentifier("lockSegue", sender: self)
    }
    
    @IBAction func unlock(segue: UIStoryboardSegue) {
        
        webDriver = (LoginCredentials.sharedInstance.bankType == .Halifax) ? HalifaxDriver(webView: WKWebView()) : HSBCDriver(webView: WKWebView())
        webDriver!.delegate = self
        webDriver!.bankDelegate = self
        self.view.addSubview(webDriver!.webview)
        webDriver!.webview.hidden = true
        
        webDriver!.loadAccounts()
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
//        self.refresh()
        
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
        webDriver!.webview.frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: height)
    }
    
    @IBAction func toggleWeb(sender : UIBarButtonItem) {
        if let driver = webDriver {
            if driver.webview.hidden {
                driver.webview.hidden = false
                tableView.hidden = true
                driver.drive = false
                sizeWebView()
            } else {
                driver.loadAccounts()
                driver.webview.hidden = true
                tableView.hidden = false
                driver.drive = true
            }
        }
    }
}

