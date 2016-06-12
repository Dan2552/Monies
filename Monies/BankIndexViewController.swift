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

        refreshToken = realm.objects(BankLogin).addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                break
            case .Error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
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
