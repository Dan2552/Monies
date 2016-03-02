//
//  PatternViewController.swift
//  Monies
//
//  Created by Daniel Green on 05/06/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if needsToCreateAccount() {
//            performSegueWithIdentifier("newBank", sender: nil)
//            return
//        }
        touchId()
    }
    
    func touchId() {
        let context = LAContext()
        var error : NSError?
        let myLocalizedReasonString = "Identify"
        
        // Allow devices without TouchID
        guard context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            allow()
            return
            
        }
        
        context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, error in
            if success {
                Async.main(after: 0) { self.allow() }
            } else {
                Async.main(after: 5) { self.touchId() }
            }
        }
    }
    
    func allow() {
        performSegueWithIdentifier("allow", sender: self)
    }
    
    func needsToCreateAccount() -> Bool {
        return Bank.existing() == nil
    }
}
