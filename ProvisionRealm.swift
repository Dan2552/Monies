//
//  ProvisionRealm.swift
//  Monies
//
//  Created by Daniel Green on 10/05/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import Foundation

func provisionRealm() {
    if let directory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.wildcard") {
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
    } else {
        NSLog("no group folder found");
    }
}