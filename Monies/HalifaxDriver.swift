import UIKit
import WebKit
import RealmSwift

protocol HalifaxDriverDelegate {
    func halifaxDriverAccountAdded(account: Account)
    func halifaxDriverLoadedPage(page: String)
}

class HalifaxDriver: WebViewDriver, AsyncronousAccountCreatorDelegate {
    var accountLinks = Array<String>()
    var currentAccount = 0
    var currentUrl = ""
    var halifaxDelegate: HalifaxDriverDelegate?
    var drive = true
    var loadAccountsInProgress = false
    var currentPageDescription = "web"
    lazy var login = Bank.existing()!
    
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
        print("Accounts")
        run("$('.balance').length") { accountCountStr in
            if let accountCount = Int(accountCountStr) {
                for i in 0..<accountCount {
                    self.parseAccount(i)
                }
            }
        }
    }
    
    func parseAccount(index: Int) {
        let creator = AsyncronousAccountCreator(delegate: self)
        
        run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-number').text()") { accountNumber in
            creator.accountNumber = accountNumber
        }
        run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.balance span').text()") { balance in
            creator.balance = balance
        }
        run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.available-balance').text()") { availableBalance in
            var ab = availableBalance
            if ab.isEmpty { ab = "-" }
            creator.availableBalance = ab
        }
        run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-name a').text()") { title in
            creator.title = title
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
    
    func accountPersisted(account: Account) {
        self.halifaxDelegate?.halifaxDriverAccountAdded(account)
    }
}
