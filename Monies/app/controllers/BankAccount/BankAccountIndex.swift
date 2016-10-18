import UIKit
import WebKit
import RealmSwift

class BankAccountIndexViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var bankAccounts: Results<BankAccount>!
    var tableView : UITableView!
    var refreshToken: NotificationToken?

    lazy var realm: Realm = { try! Realm() }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        tableView = setupTableView(style: .Plain)
        
        self.tableView.addSubview(refreshControl)

        refreshToken = realm.objects(BankAccount).addNotificationBlock { (changes: RealmCollectionChange) in
            self.refreshControl.endRefreshing()
            self.refresh()
        }
        refresh()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AccountTableViewCell.height
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        DriverManager.sharedInstance.refreshAccounts()
    }

    func refresh() {
        let realm = try! Realm()
        bankAccounts = realm.objects(BankAccount)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(bankAccounts?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuse = "overview cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuse) as? AccountTableViewCell ??
            AccountTableViewCell(style: .Default, reuseIdentifier: reuse)
        
        cell.setContentForAccount(bankAccountFor(indexPath))
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        try! realm.write {
            bankAccountFor(indexPath).toggleIsBalanceShown()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func bankAccountFor(indexPath: NSIndexPath) -> BankAccount {
        return bankAccounts[Int(indexPath.row)]
    }
}

