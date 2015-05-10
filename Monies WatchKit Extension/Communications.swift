//
//  Communications.swift
//  Monies
//
//  Created by Daniel Green on 04/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WatchKit

class Communications {
   
    class func callToParent(action: String, callback: (response: String) -> Void) {        WKInterfaceController.openParentApplication(["action": action]) { replyInfo, error in
            if error != nil {
                println("oh noes D:")
                println(error)
                return
            }
        
            if replyInfo == nil {
                return
            }
        
            let response = replyInfo["response"] as! String
            if response.hasPrefix("refreshing") {
                Async.main(after: 1) {
                    self.callToParent("refreshed?", callback: callback)
                }
            }
        
            callback(response: response)
        }
    }
    
}
