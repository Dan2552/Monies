import UIKit
import DateTools

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var available: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    var updatedAt = NSDate()
    
    func setContentForAccount(account: Account) {
        accountName.text = account.title
        available.text =  account.balance
        updatedAt = account.updatedAtDate()
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        self.timeAgoLabel.text = self.updatedAt.timeAgoSinceNow()
        Async.main(after: 1) { self.updateTimeAgo() }
    }
}

