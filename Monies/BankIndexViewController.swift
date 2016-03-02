import UIKit
import RealmSwift

class BankIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var banks: Results<Bank>?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidAppear(animated: Bool) {
        banks = Bank().r.objects(Bank)
        tableView.reloadData()

        navigationController?.title = "Banks"
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
        print("segue!")
        if let destination = segue.destinationViewController as? DriverShowViewController {
            print("detected as driver")
            destination.bank = bankAtIndexPath(tableView.indexPathForSelectedRow!)
        }
        print("?")
    }

    func bankAtIndexPath(indexPath: NSIndexPath) -> Bank {
        return banks![Int(indexPath.row)]
    }

}
