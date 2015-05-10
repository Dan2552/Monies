//
//  AppDelegate.swift
//  Monies
//
//  Created by Daniel Green on 05/06/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    let halifax = HalifaxDriver(webView: WKWebView())
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        provisionRealm()
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        // Suggested "fix" from http://www.fiveminutewatchkit.com/blog/2015/3/11/one-weird-trick-to-fix-openparentapplicationreply
        // --------------------
        var bogusWorkaroundTask: UIBackgroundTaskIdentifier?
        bogusWorkaroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler() {
            UIApplication.sharedApplication().endBackgroundTask(bogusWorkaroundTask!)
        }
        Async.main(after: 2) {
            UIApplication.sharedApplication().endBackgroundTask(bogusWorkaroundTask!)
        }
        // --------------------
        
        let info = userInfo as! [String: String]
        let action = info["action"]!
    
        if action == "refresh" {
            var backgroundTask: UIBackgroundTaskIdentifier?
            backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler() {
                println("expiring :(")
                reply(nil)
                UIApplication.sharedApplication().endBackgroundTask(backgroundTask!)
            }
            
            halifax.drive = true
            halifax.loadAccounts()
            stopTaskWhenFinished(backgroundTask!)
            
            reply(["response": "refreshing"])
        } else if action == "refreshed?" {
            if self.halifax.loadAccountsInProgress {
                reply(["response": "refreshing \(self.halifax.currentPageDescription)"])
            } else {
                reply(["response": "refreshed!"])
            }
        } else {
            reply(nil)
        }
    }
    
    func stopTaskWhenFinished(backgroundTask: UIBackgroundTaskIdentifier) {
        Async.main(after: 0.2) {
            if self.halifax.loadAccountsInProgress {
                println("not yet...")
            } else {
                UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
                println("done!")
            }

        }
    }
}

