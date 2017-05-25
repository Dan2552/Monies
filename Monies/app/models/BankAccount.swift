import RealmSwift

class BankAccount: Object {
    //belongs_to :bank

    dynamic var accountNumber = ""
    dynamic var balance = ""
    dynamic var availableBalance = ""
    dynamic var title = ""
    dynamic var updatedAt = ""
    dynamic var isBalanceShown = false
    
    func updatedAtDate() -> Date {
        let interval = (updatedAt as NSString).doubleValue
        return Date(timeIntervalSince1970: interval)
    }
    
    func toggleIsBalanceShown() {
        isBalanceShown = !isBalanceShown
    }
}
