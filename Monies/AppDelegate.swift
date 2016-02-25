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
        Style().setDark()

        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
}

