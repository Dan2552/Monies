import UIKit
import DateTools
import Async
import PureLayout

class AccountTableViewCell: UITableViewCell {
    static let height: CGFloat = {
        return padding + largeLabelHeight + betweenLabels + normalLabelHeight + betweenLabels + normalLabelHeight + padding
    }()
    
    static let padding: CGFloat = 8
    static let betweenLabels: CGFloat = 2
    
    let accountName = UILabel()
    let available = UILabel()
    let timeAgo = UILabel()
    let balance = UILabel()
    
    var updatedAt = NSDate()
    
    private static let largeLabelHeight: CGFloat = 35
    private static let normalLabelHeight: CGFloat = 20
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let padding = AccountTableViewCell.padding
        let largeLabelHeight = AccountTableViewCell.largeLabelHeight
        let normalLabelHeight = AccountTableViewCell.normalLabelHeight
        let betweenLabels = AccountTableViewCell.betweenLabels
        
        [accountName, available, timeAgo, balance].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        let timeAgoWidth: CGFloat = 44
        
        timeAgo.autoPinEdge(.Top, toEdge: .Top, ofView: self)
        timeAgo.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
        timeAgo.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: -padding)
        timeAgo.autoSetDimension(.Width, toSize: timeAgoWidth)
        timeAgo.numberOfLines = 0
        timeAgo.font = Style().font(.Small)
        timeAgo.textAlignment = .Center
        timeAgo.textColor = Style().primaryColor
        
        [accountName, available, balance].forEach {
            $0.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: padding)
            $0.autoPinEdge(.Right, toEdge: .Right, ofView: self, withOffset: (padding + timeAgoWidth + padding))
        }
        
        accountName.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: padding)
        accountName.autoSetDimension(.Height, toSize: normalLabelHeight)
        accountName.font = Style().font(.Normal)
        
        available.autoPinEdge(.Top, toEdge: .Bottom, ofView: accountName, withOffset: betweenLabels)
        available.autoSetDimension(.Height, toSize: largeLabelHeight)
        available.font = Style().font(.Large)
        
        balance.autoPinEdge(.Top, toEdge: .Bottom, ofView: available, withOffset: betweenLabels)
        balance.autoSetDimension(.Height, toSize: normalLabelHeight)
        balance.font = Style().font(.Normal)
    }
    
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
        timeAgo.text = updatedAt.timeAgoSinceNow()
        Async.main(after: 1) { self.updateTimeAgo() }
    }
}