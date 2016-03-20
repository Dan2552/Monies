import UIKit
import WebKit
import RealmSwift

class OverviewViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var accounts: Results<BankAccount>?
    @IBOutlet var tableView : UITableView!
    var refreshToken: NotificationToken?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(refreshControl)

        let realm = try! Realm()
        refreshToken = realm.objects(BankAccount).addNotificationBlock { results, error in
            self.accounts = results
            self.refresh()
            self.refreshControl.endRefreshing()
        }
        refresh()
    }

    deinit {
        refreshToken?.stop()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        DriverManager.sharedInstance.refreshAccounts()
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }

    func refresh() {
        let realm = try! Realm()
        accounts = realm.objects(BankAccount)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(accounts?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AccountTableViewCell
        let account = accounts![Int(indexPath.row)]
        cell.setContentForAccount(account)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let account = accounts![Int(indexPath.row)]
        try! account.realm?.write {
            account.isBalanceShown = !account.isBalanceShown
        }
        tableView.reloadData()

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

