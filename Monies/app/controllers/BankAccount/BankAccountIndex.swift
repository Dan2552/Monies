import UIKit
import WebKit
import RealmSwift
import Async

class BankAccountIndexViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var bankAccounts: Results<BankAccount>!
    var tableView : UITableView!
    var refreshToken: NotificationToken?

    lazy var realm: Realm = { try! Realm() }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        tableView = setupTableView(style: .plain)
        
        self.tableView.addSubview(refreshControl)

        refreshToken = realm.objects(BankAccount.self).addNotificationBlock { (changes: RealmCollectionChange) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshControl.endRefreshing()
            self.refresh()
        }
        refresh()
        
        Async.main(after: 1) {
            DriverManager.sharedInstance.refreshAccounts()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountTableViewCell.height
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        DriverManager.sharedInstance.refreshAccounts()
    }

    func refresh() {
        let realm = try! Realm()
        bankAccounts = realm.objects(BankAccount.self)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(bankAccounts?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuse = "overview cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse) as? AccountTableViewCell ??
            AccountTableViewCell(style: .default, reuseIdentifier: reuse)
        
        cell.setContentForAccount(bankAccountFor(indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write {
            bankAccountFor(indexPath).toggleIsBalanceShown()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func bankAccountFor(_ indexPath: IndexPath) -> BankAccount {
        return bankAccounts[Int(indexPath.row)]
    }
}

