import UIKit
import DateTools
import Async
import PureLayout
import ChameleonFramework

class AccountTableViewCell: UITableViewCell {
    static let height: CGFloat = {
        return padding
            + largeLabelHeight
            + betweenLabels
            + normalLabelHeight
            + betweenLabels
            + normalLabelHeight
            + padding
    }()
    
    static let padding: CGFloat = 16
    static let betweenLabels: CGFloat = 2
    
    let accountName = UILabel()
    let available = UILabel()
    let timeAgo = UILabel()
    let balance = UILabel()
    var background: UIView!
    
    var updatedAt = Date()
    
    fileprivate static let largeLabelHeight: CGFloat = 30
    fileprivate static let normalLabelHeight: CGFloat = 25
    
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
        
        background = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                          size: CGSize(width: frame.width,
                                                       height: AccountTableViewCell.height)))
        background.layer.cornerRadius = 0
        background.layer.masksToBounds = true
        addSubview(background)
        
        [accountName, available, timeAgo, balance].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            addSubview($0)
        }
        
        let timeAgoWidth: CGFloat = 44
        
        timeAgo.autoPinEdge(.top, to: .top, of: self)
        timeAgo.autoPinEdge(.bottom, to: .bottom, of: self)
        timeAgo.autoPinEdge(.right, to: .right, of: self, withOffset: -padding)
        timeAgo.autoSetDimension(.width, toSize: timeAgoWidth)
        timeAgo.numberOfLines = 0
        timeAgo.font = Style().font(size: .small)
        timeAgo.textAlignment = .center
        timeAgo.textColor = .white
        
        [accountName, available, balance].forEach {
            $0.autoPinEdge(.left, to: .left, of: self, withOffset: padding)
            $0.autoPinEdge(.right, to: .right, of: self, withOffset: (padding + timeAgoWidth + padding))
        }
        
        background.autoPinEdgesToSuperviewEdges()
        
        accountName.autoPinEdge(.top, to: .top, of: self, withOffset: padding)
        accountName.autoSetDimension(.height, toSize: normalLabelHeight)
        accountName.font = Style().font(size: .normal)
        
        available.autoPinEdge(.top, to: .bottom, of: accountName, withOffset: betweenLabels)
        available.autoSetDimension(.height, toSize: largeLabelHeight)
        available.font = Style().font(size: .large)
        
        balance.autoPinEdge(.top, to: .bottom, of: available, withOffset: betweenLabels)
        balance.autoSetDimension(.height, toSize: normalLabelHeight)
        balance.font = Style().font(size: .normal)
    }
    
    func setContentForAccount(_ account: BankAccount, row: Int) {
        accountName.text = account.title
        if account.isBalanceShown {
            available.text = "\(account.availableBalance) available"
            balance.text = account.balance
            
            background.backgroundColor = [
                .flatBlue,
                .flatGreen,
                .flatYellow,
                .flatWatermelon,
                .flatRed,
                .flatPlum,
                .flatPurple
            ][row % 7]
        } else {
            available.text = "--------"
            balance.text = "--------"
            
            background.backgroundColor = .flatWhite
        }
        updatedAt = account.updatedAtDate()
        updateTimeAgo()
    }
    
    func updateTimeAgo() {
        timeAgo.text = (updatedAt as NSDate).timeAgoSinceNow()
        Async.main(after: 1) { self.updateTimeAgo() }
    }
}
