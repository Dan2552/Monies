import UIKit
import RealmSwift

class BankIndexViewController: UITableViewController {
    var banks: Results<Bank>?

    override func viewDidAppear(animated: Bool) {
        banks = Bank().r.objects(Bank)
        (view as! UITableView).reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(banks?.count ?? 0)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let bank = bankAtIndexPath(indexPath)
        cell.textLabel?.text = bank.username
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DriverShowViewController {
            destination.bank = bankAtIndexPath(tableView.indexPathForSelectedRow!)
        }
    }

    func bankAtIndexPath(indexPath: NSIndexPath) -> Bank {
        return banks![Int(indexPath.row)]
    }

}
