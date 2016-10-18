import UIKit
import RealmSwift

class BankLoginIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var bankLogins: Results<BankLogin>!
    var tableView: UITableView!
    var refreshToken: NotificationToken?

    override func viewDidLoad() {
        let realm = BankLogin().r
        bankLogins = realm.objects(BankLogin)

        tableView = setupTableView(style: .Plain)

        refreshToken = bankLogins.addNotificationBlock { (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(bankLogins?.count ?? 0)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuse = "bank cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuse) ?? UITableViewCell(style: .Default, reuseIdentifier: reuse)
        let bankLogin = bankLoginAtIndexPath(indexPath)
        cell.textLabel?.text = bankLogin.username
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bankLogin = bankLoginAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        NavigationFlow().presentBankLogin(from: self, bankLogin: bankLogin)
    }

    func bankLoginAtIndexPath(indexPath: NSIndexPath) -> BankLogin {
        return bankLogins[Int(indexPath.row)]
    }
}
