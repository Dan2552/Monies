import UIKit
import RealmSwift

class BankLoginIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var bankLogins: Results<BankLogin>!
    var tableView: UITableView!
    var refreshToken: NotificationToken?

    override func viewDidLoad() {
        let realm = BankLogin().r
        bankLogins = realm.objects(BankLogin.self)

        tableView = setupTableView(style: .plain)

        refreshToken = bankLogins.addNotificationBlock { (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(bankLogins?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuse = "bank cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse) ?? UITableViewCell(style: .default, reuseIdentifier: reuse)
        let bankLogin = bankLoginAtIndexPath(indexPath)
        cell.textLabel?.text = bankLogin.username
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bankLogin = bankLoginAtIndexPath(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        NavigationFlow().presentBankLogin(from: self, bankLogin: bankLogin)
    }

    func bankLoginAtIndexPath(_ indexPath: IndexPath) -> BankLogin {
        return bankLogins[Int(indexPath.row)]
    }
}
