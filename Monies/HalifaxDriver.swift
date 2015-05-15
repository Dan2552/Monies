//
//  HalifaxDriver.swift
//  MoniesMac
//
//  Created by Daniel Green on 05/11/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import WebKit

class HalifaxDriver: BankWebDriver {

    var accountLinks = Array<String>()
    var currentAccount = 0
    var currentUrl = ""
    var accounts: RLMArray
    var drive = true
    var loadAccountsInProgress = false
    var currentPageDescription = "web"
    
    override init(webView: WKWebView) {
        accounts = RLMArray(objectClassName: "HalifaxAccount")
        let objs = HalifaxAccount.allObjects()
        accounts.addObjects(objs)
        
        super.init(webView: webView)
    }
    
    func loadedPage(name: String) {
        println(name)
        currentPageDescription = name
        bankDelegate?.bankDriverDelegateLoadedPage(name)
    }
    
    override func pageLoaded(url : String) {

        currentUrl = url
        println("--------- Page loaded --------- ")
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
            println("Unknown page: \(url)")
            ifSignedOut() {
                println("Detected user has been signed out...")
            }
        }
    }
    
    override func loadAccounts() {
        loadAccountsInProgress = true
        println("loadAccounts called")
        self.visit("https://secure.halifax-online.co.uk/personal/a/mobile/account_overview/")
    }
    
    func loginStep1() {
        println("Signing in (part 1)")
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.fillIn("frmLogin:strCustomerLogin_userID", with: username, completion: next) },
            { result, next in self.fillIn("frmLogin:strCustomerLogin_pwd", with: password, completion: next) },
            { result, next in self.click("frmLogin:lnkLogin1", completion: next)}
        ])
    }
    
    func loginStep2() {
        println("Signing in (part 2)")
        for i in 1...3 {
            var element = "frmEnterMemorableInformation1:formMem\(i)"
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
        //TODO: Use something like http://apidock.com/rails/ActiveSupport/Inflector/ordinalize
        var labels = [ "1st:", "2nd:", "3rd:", "4th:", "5th:", "6th:", "7th:", "8th:", "9th:", "10th:"]
        
        var n = -1
        for (index, label) in enumerate(labels) { if (key == label) { n = index } }
        if n > -1 { return "&nbsp;\(Array(password)[n])" }
        return ""
    }
    
    override func getAccounts() {
        accounts.removeAllObjects()
        println("Accounts")
        run("document.getElementsByClassName('accountItem').length") { accountCountStr in
            if let accountCount = accountCountStr.toInt() {
                self.accountLinks = Array<String>()
                
                for i in 0..<accountCount {
                    self.run("document.getElementById('lstAccLst:\(i):currentlnk').href") { link in
                        self.oneAtATime() {
                            if !contains(self.accountLinks, link) {
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
            bankDelegate?.bankDriverDelegateLoadedPage("done")
        }
    }

    func getAccountInfo() {
        let url = currentUrl
        println("Account details page")
        singleAccountScreenHeading() { heading in
            self.singleAccountScreenAccountDetails() { details in
                let realm = RLMRealm.defaultRealm()
                let existing = HalifaxAccount.objectsWhere("url = '\(url)'")
                println("persisting... \(self.currentPageDescription)")
                let account = (existing.firstObject() as! HalifaxAccount?) ?? HalifaxAccount()
                realm.transactionWithBlock() {
                    account!.setFromDetails(heading, details: details, url: url)
                    realm.addObject(account!)
                    println("persisted")
                }
                self.accounts.addObject(account)
                self.bankDelegate?.bankDriverDelegateAccountAdded(account!)
                self.nextAccount()
            }
        }
    }
}
