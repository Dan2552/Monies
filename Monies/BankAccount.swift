import RealmSwift

class BankAccount: Object {
    //belongs_to :bank

    dynamic var accountNumber = ""
    dynamic var balance = ""
    dynamic var availableBalance = ""
    dynamic var title = ""
    dynamic var updatedAt = ""
    dynamic var isBalanceShown = false
    
    func updatedAtDate() -> NSDate {
        let interval = (updatedAt as NSString).doubleValue
        return NSDate(timeIntervalSince1970: interval)
    }
}
