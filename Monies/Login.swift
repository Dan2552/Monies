//
//  Login.swift
//  Monies
//
//  Created by Dan on 16/02/2016.
//  Copyright © 2016 Daniel Green. All rights reserved.
//

import RealmSwift
import Luncheon

class Login: Object, Lunch {
    dynamic var username = ""
    dynamic var password = ""
    dynamic var memorableInformation = ""
    
    lazy var r = try! Realm()
    
    func isValid() -> Bool {
        return username.characters.count > 0 && password.characters.count > 0 && memorableInformation.characters.count > 0
    }
    
    func create() -> Bool {
        if !isValid() { return false }
        try! r.write { self.r.add(self) }
        return true
    }
    
    class func existing() -> Login? {
        return self.init().r.objects(self).first
    }
}