import Foundation
import RealmSwift

protocol AsyncronousAccountCreatorDelegate {
    func accountPersisted(account: Account)
}

class AsyncronousAccountCreator {
    var accountNumber = "" { didSet { propertyWasSet() } }
    var balance = "" { didSet { propertyWasSet() } }
    var availableBalance = "" { didSet { propertyWasSet() } }
    var title = "" { didSet { propertyWasSet() } }
    var delegate: AsyncronousAccountCreatorDelegate
    
    lazy var realm = try! Realm()
    
    init(delegate: AsyncronousAccountCreatorDelegate) {
        self.delegate = delegate
    }
    
    func propertyWasSet() {
        if accountNumber.isEmpty || balance.isEmpty || availableBalance.isEmpty || title.isEmpty {
            return
        }
        
        let existing = realm.objects(Account).filter("accountNumber == '\(accountNumber)'")
        let account = existing.first ?? Account.init()
        try! realm.write {
            account.accountNumber = accountNumber
            account.balance = balance
            account.availableBalance = availableBalance
            account.title = title
            account.updatedAt = "\(NSDate().timeIntervalSince1970)"
            realm.add(account)
            delegate.accountPersisted(account)
            print("persisted")
        }
    }
    
}