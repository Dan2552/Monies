//
//  HSBCDriver.swift
//  Monies
//
//  Created by Tim Preuß on 14.05.15.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

import WebKit

class HSBCDriver: BankWebDriver {
    var accountLinks = Array<String>()
    var currentAccount = 0
    var currentUrl = ""
    var accounts: RLMArray
    var drive = true
    var loadAccountsInProgress = false
    var currentPageDescription = "web"
    
    override init(webView: WKWebView) {
        accounts = RLMArray(objectClassName: "HSBCAccount")
        let objs = HSBCAccount.allObjects()
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
        println(currentUrl)
        if !drive { return }
        
        if url.hasSuffix("hsbc.co.uk/1/2/mobile") {
            loadedPage("frontpage")
            gotoLoginScreen()
        } else if url.hasSuffix("?IDV_URL=hsbc.mobile.MyHSBC_pib") {
            loadedPage("login1")
            loginStep1()
        } else if url.hasSuffix("security.hsbc.co.uk/gsa/SaaS30Resource/") {
            loadedPage("withSecKey")
            switchToLoginPageWithoutSecKey()
        } else if url.hasSuffix("?__USER=withOutSecKey") {
            loadedPage("withoutSecKey")
            loginStep2()
        } else if url.hasSuffix("personal/online-banking?BlitzToken=blitz") {
            loadedPage("accounts")
            getAccounts()
        }
    }
    
    override func loadAccounts() {
        loadAccountsInProgress = true
        println("loadAccounts called")
        self.visit("http://www.hsbc.co.uk/1/2/mobile")
    }
    
    func gotoLoginScreen() {
        println("Signing in (part 1)")
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.clickClass("redBtn", completion: next)}
            ])
    }
    
    func loginStep1() {
        println("Signing in (part 1)")
        
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.fillInElement(self.elementAtIndex(self.elementsByName("userid"), index: 0), with: username, completion: next)},
            { result, next in self.click("registerStep1Submit", completion: next)}
            ])
    }
    
    func switchToLoginPageWithoutSecKey() {
        println("Signing in (switching to login page without SecKey)")
        
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.clickElement(self.elementAtIndex(self.elementsByClassName("listStyle02inner"), index: 1), completion: next)},
            ])
    }
    
    func loginStep2() {
        println("Signing in (part 2)")

        WKWebKitAsyncRunner(tasks: [
            { result, next in self.fillInElement(self.elementById("memorableAnswer"), with: memorableAnswer, completion: next)}
            ])
        
        for i in 0...5 {
            let element = self.elementsByQuerySelector(".active#pass\(i+1)")
            WKWebKitAsyncRunner(tasks: [
                { result, next in self.fillInElement(element, with:"\(Array(password)[i])", completion: next)}
                ])
        }
        for i in reverse(0...1) {
            let element = self.elementsByQuerySelector(".active#pass\(8-i)")
            WKWebKitAsyncRunner(tasks: [
                { result, next in self.fillInElement(element, with:"\(Array(password)[count(password)-1 - i])", completion: next)}
                ])
        }
        
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.clickElement(self.elementAtIndex(self.elementsByClassName("submit_input"), index: 0), completion: next)}
            ])
    }
    
    
    override func getAccounts() {
        accounts.removeAllObjects()
        println("Accounts")
        run("document.getElementsByClassName('col3')[2].firstChild.innerHTML") { result in
            let realm = RLMRealm.defaultRealm()
            let existing = HSBCAccount.objectsWhere("url = '\(self.currentUrl)'")
            println("persisting... \(self.currentPageDescription)")
            let account = (existing.firstObject() as! HSBCAccount?) ?? HSBCAccount()
            realm.transactionWithBlock() {
                account!.setFromDetails("", details: result, url: self.currentUrl)
                realm.addObject(account!)
                println("persisted")
            }
            self.accounts.addObject(account)
            self.bankDelegate?.bankDriverDelegateAccountAdded(account!)
        }
        
        // logout
        WKWebKitAsyncRunner(tasks: [
            { result, next in self.clickElement(self.elementAtIndex(self.elementsByName("login"), index: 0), completion: next)}
            ])
    }
}
