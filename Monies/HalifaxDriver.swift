//
//  HalifaxDriver.swift
//  MoniesMac
//
//  Created by Daniel Green on 05/11/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

protocol HalifaxDriverDelegate {
    func halifaxDriverAccountAdded(account: HalifaxAccount)
    func halifaxDriverLoadedPage(page: String)
}



class HalifaxDriver: WebViewDriver {

    var accountLinks = Array<String>()
    var currentAccount = 0
    var currentUrl = ""
//    var accounts: Results<HalifaxAccount>
    var halifaxDelegate: HalifaxDriverDelegate?
    var drive = true
    var loadAccountsInProgress = false
    var currentPageDescription = "web"
    lazy var login = Login.existing()!
    
    override init(webView: WKWebView) {
//        let realm = try! Realm()
//        let objs = realm.objects(HalifaxAccount)
//        accounts.addObjects(objs)
        
        super.init(webView: webView)
    }
    
    func loadedPage(name: String) {
        print(name)
        currentPageDescription = name
        halifaxDelegate?.halifaxDriverLoadedPage(name)
    }
    
    override func pageLoaded(url : String) {

        currentUrl = url
        print("--------- Page loaded --------- ")
        if !drive { return }
        
        if url.hasPrefix("https://www.halifax-online.co.uk/personal/logon/login.jsp") {
            loadedPage("login1")
            loginStep1()
        } else if url.hasSuffix("logon/entermemorableinformation.jsp") {
            loadedPage("login2")
            loginStep2()
        } else if url.hasSuffix("mobile/account_overview/") {
            loadedPage("accounts")
            getAccounts()
        } else if (url as NSString).containsString("mobile/account_details/") {
            loadedPage("account\(currentAccount)")
            getAccountInfo()
        } else {
            loadedPage("unknown")
            print("Unknown page: \(url)")
            ifSignedOut() {
                print("Detected user has been signed out...")
            }
        }
    }
    
    func loadAccounts() {
        loadAccountsInProgress = true
        print("loadAccounts called")
        self.visit("https://secure.halifax-online.co.uk/personal/a/mobile/account_overview/")
    }
    
    func loginStep1() {
        print("Signing in (part 1)")
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.fillIn("frmLogin:strCustomerLogin_userID", with: self.login.username, completion: next) },
            { result, next in self.fillIn("frmLogin:strCustomerLogin_pwd", with: self.login.password, completion: next) },
            { result, next in self.click("frmLogin:lnkLogin1", completion: next)}
        ])
    }
    
    func loginStep2() {
        print("Signing in (part 2)")
        for i in 1...3 {
            let element = "frmEnterMemorableInformation1:formMem\(i)"
            WKWebKitAsyncRunner(tasks: [
                { result, next in self.labelFor(element, completion: next) },
                { result, next in self.fillIn(element, with: self.characterForLabel(result), completion: next)},
                { result, next in if i == 3 { self.click("frmEnterMemorableInformation1:lnkSubmit", completion: next) } }
            ])
        }
    }
    
    func ifSignedOut(conditionClosure: (() -> Void)) {
        run("document.body.innerHTML") { result in
            if (result as NSString).containsString("Sorry, for security we've signed you out") {
                conditionClosure()
            }
        }
    }

    func characterForLabel(key:String) -> String {
        var labels = [String]()
        for i in 1...100 {
            labels.append("\(i.ordinalizedString):")
        }
        
        var n = -1
        for (index, label) in labels.enumerate() { if (key == label) { n = index } }
        if n > -1 { return "&nbsp;\(Array(self.login.memorableInformation.characters)[n])" }
        return ""
    }
    
    func getAccounts() {
//        accounts.removeAllObjects()
        print("Accounts")
        run("document.getElementsByClassName('accountItem').length") { accountCountStr in
            if let accountCount = Int(accountCountStr) {
                self.accountLinks = Array<String>()
                
                for i in 0..<accountCount {
                    self.run("document.getElementById('lstAccLst:\(i):currentlnk').href") { link in
                        self.oneAtATime() {
                            if !self.accountLinks.contains(link) {
                                self.accountLinks.append(link)
                                
                                if self.accountLinks.count == accountCount {
                                    self.navigateToAccount(0)
                                }
                            }
                        }
                    }
                }
            }
        }
     }
    

    func singleAccountScreenHeading(completion: (String) -> ()) {
        run("document.getElementsByClassName('accountDetailsHeading')[0].innerText", completion: completion)
    }

    func singleAccountScreenAccountDetails(completion: (String) -> ()) {
        run("document.getElementsByClassName('accountDetails')[0].innerText", completion: completion)
    }

    func navigateToAccount(account: Int) {
        currentAccount = account
        visit("\(accountLinks[account])")
    }
    
    func nextAccount() {
        if (currentAccount < accountLinks.count - 1) {
            navigateToAccount(currentAccount + 1)
        } else {
            loadAccountsInProgress = false
            halifaxDelegate?.halifaxDriverLoadedPage("done")
        }
    }

    func getAccountInfo() {
        let url = currentUrl
        print("Account details page")
        singleAccountScreenHeading() { heading in
            self.singleAccountScreenAccountDetails() { details in
                let realm = try! Realm()

                let existing = realm.objects(HalifaxAccount).filter("url == '\(url)'")
                print("persisting... \(self.currentPageDescription)")
                let account = existing.first ?? HalifaxAccount()
                try! realm.write {
                    account.setFromDetails(heading, details: details, url: url)
                    realm.add(account)
                    print("persisted")
                }
//                self.accounts.add(account)
                self.halifaxDelegate?.halifaxDriverAccountAdded(account)
                self.nextAccount()
            }
        }
    }
}
