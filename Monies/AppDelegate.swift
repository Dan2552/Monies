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
    var backgroundTask: UIBackgroundTaskIdentifier?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        let info = userInfo as! [String: String]
        let action = info["action"]!
    
        if action == "refresh" {
            backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler() {
                println("expiring :(")
            }
            
            halifax.drive = true
            halifax.loadAccounts()
            stopTaskWhenFinished()
            
            reply(["response": "refreshing"])
        } else if action == "refreshed?" {
            if self.halifax.loadAccountsInProgress {
                reply(["response": "refreshing \(self.halifax.currentPageDescription)"])
            } else {
                reply([
                    "response": "refreshed!",
                    "objects": HalifaxAccount.allObjectsAsArrayOfDictionariesForWatch()
                ])
            }
        } else {
            reply([
                "response": "current",
                "objects": HalifaxAccount.allObjectsAsArrayOfDictionariesForWatch()
            ])
        }
    }
    
    func stopTaskWhenFinished() {
        Async.main(after: 1) {
            if self.halifax.loadAccountsInProgress {
                println("not yet...")
                println("\(self.halifax.webview)")
                println("\(self.halifax.webview.URL)")
                //self.stopTaskWhenFinished()
            } else {
                if let task = self.backgroundTask { UIApplication.sharedApplication().endBackgroundTask(task) }
                println("done!")
            }

        }
    }
}

