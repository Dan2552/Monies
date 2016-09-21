import UIKit
import DateTools

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    var updatedAt = NSDate()
    
    func setContentForAccount(account: BankAccount) {
        accountName.text = account.title
        if account.isBalanceShown {
            available.text = "\(account.availableBalance) available"
            balance.text = account.balance
        } else {
            available.text = "--------"
            balance.text = "--------"
        }
        updatedAt = account.updatedAtDate()
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        self.timeAgoLabel.text = self.updatedAt.timeAgoSinceNow()
        Async.main(after: 1) { self.updateTimeAgo() }
    }


}

