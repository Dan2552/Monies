import Foundation
import RealmSwift

class AsyncronousAccountCreator {
    var accountNumber = "" { didSet { propertyWasSet() } }
    var balance = "" { didSet { propertyWasSet() } }
    var availableBalance = "" { didSet { propertyWasSet() } }
    var title = "" { didSet { propertyWasSet() } }

    lazy var realm = try! Realm()

    func propertyWasSet() {
        if accountNumber.isEmpty || balance.isEmpty || availableBalance.isEmpty || title.isEmpty {
            return
        }
        
        let existing = realm.objects(BankAccount).filter("accountNumber == '\(accountNumber)'")
        let account = existing.first ?? BankAccount.init()
        try! realm.write {
            account.accountNumber = accountNumber
            account.balance = balance
            account.availableBalance = availableBalance
            account.title = title
            account.updatedAt = "\(NSDate().timeIntervalSince1970)"
            realm.add(account)
            print("persisted")
        }
    }
    
}