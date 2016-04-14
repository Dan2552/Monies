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

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()

        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()

        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor()

        return [share, favorite, more]
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}
