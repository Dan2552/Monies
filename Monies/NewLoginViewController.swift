//
//  AccountLoginViewController.swift
//  Monies
//
//  Created by Dan on 16/02/2016.
//  Copyright © 2016 Daniel Green. All rights reserved.
//

import UIKit
import XLForm
import Luncheon
import Napkin

class NewLoginViewController: NapkinViewController {
    var login = Login()
    
    override func saveWasTapped() {
        if login.create() {
            super.saveWasTapped()
        } else {
            let alert = UIAlertController(title: nil, message: "Fill in all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func setValuesToSubject() {
        try! login.r.write { super.setValuesToSubject() }
    }
    override func subject() -> Lunch {
        return self.login
    }
    
    override func setupFields() {
        input("username")
        input("password")
        input("memorableInformation")
        
//        sectionSeparator()
//        input("width")
//        input("height")
//        
//        sectionSeparator()
//        input("tileset", collection: [
//            0: "Interior",
//            1: "Test Landscape"
//            ])
//        input("scale")
//        
//        if let r = mapConfig.realm {
//            sectionSeparator()
//            button("Delete") {
//                self.mapConfig.deleteFile()
//                r.write { r.delete(self.mapConfig) }
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
    }
}