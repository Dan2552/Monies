import UIKit
import RealmSwift

class BankIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var banks: Results<BankLogin>?
    @IBOutlet weak var tableView: UITableView!
    var refreshToken: NotificationToken?

    override func viewDidLoad() {
        let realm = BankLogin().r
        banks = realm.objects(BankLogin)
        tableView.reloadData()

        navigationController?.title = "Banks"

        refreshToken = realm.objects(BankLogin).addNotificationBlock { results, error in
            self.banks = results
            self.tableView.reloadData()
        }
    }

    deinit {
        refreshToken?.stop()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(banks?.count ?? 0)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let bank = bankAtIndexPath(indexPath)
        cell.textLabel?.text = bank.username
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? BankShowViewController {
            destination.bank = bankAtIndexPath(tableView.indexPathForSelectedRow!)
        }
    }

    func bankAtIndexPath(indexPath: NSIndexPath) -> BankLogin {
        return banks![Int(indexPath.row)]
    }
}
