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
    let refreshControl = UIRefreshControl()
    var unlockNeeded = true
    
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet var toggleWebButton : UIBarButtonItem!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lock", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        // Initialize the refresh control.
        refreshControl.addTarget(self, action: "reloadAccounts", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        setProgressVisible(false)
    }
    
    @IBAction func unlock(segue: UIStoryboardSegue) {

        unlockNeeded = false
        refresh()
        
        reloadAccounts()
    }
    
    func reloadAccounts() {
        webDriver = (LoginCredentials.sharedInstance.bankType == .Halifax) ? HalifaxDriver(webView: WKWebView()) : HSBCDriver(webView: WKWebView())
        webDriver!.delegate = self
        webDriver!.bankDelegate = self
        self.view.addSubview(webDriver!.webview)
        webDriver!.webview.hidden = true
        
        webDriver!.loadAccounts()
        setProgressVisible(true)
    }
    
    func webViewDriverProgress(progress: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = progress
    }
    
    func bankDriverDelegateRunning(running: Bool) {
        setProgressVisible(running)
    }
    
    func bankDriverDelegateAccountAdded(account: BankAccount) {
        refresh()
    }

    func bankDriverDelegateLoadedPage(pageName: String, percent: Float) {
        progressText.text = pageName
        progressView.setProgress(percent, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (unlockNeeded) {
            performSegueWithIdentifier("lockSegue", sender: self)
        }
    }
    
    func lock() {
        unlockNeeded = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        webViewDriverProgress(false)
    }
    
    func refresh() {
        accounts = HSBCAccount.allObjects()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setProgressVisible(visible: Bool) {
        let alpha = CGFloat(visible ? 1.0 : 0.0)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.progressText.alpha = alpha
            self.progressView.alpha = alpha
        }
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

