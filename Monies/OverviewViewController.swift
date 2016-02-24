import UIKit
import WebKit
import RealmSwift

class OverviewViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, WebViewDriverProgressDelegate, HalifaxDriverDelegate {

    let halifax = (UIApplication.sharedApplication().delegate as! AppDelegate).halifax
    var accounts: Results<Account>?
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        halifax.delegate = self
        halifax.halifaxDelegate = self
        halifax.loadAccounts()
    }
    
    func webViewDriverProgress(progress: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = progress
    }
    
    func halifaxDriverAccountAdded(account: Account) {
        refresh()
    }
    
    func halifaxDriverLoadedPage(page: String) {
        toggleWebButton.title = page
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    override func viewWillDisappear(animated: Bool) {
        webViewDriverProgress(false)
    }
    
    func refresh() {
        let realm = try! Realm()
        accounts = realm.objects(Account)
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

    
    @IBOutlet var toggleWebButton : UIBarButtonItem!
    
    @IBAction func toggleWeb(sender : UIBarButtonItem) {
//        if halifax.webview.hidden {
//            halifax.webview.hidden = false
//            tableView.hidden = true
//            halifax.drive = false
//        } else {
//            halifax.loadAccounts()
//            halifax.webview.hidden = true
//            tableView.hidden = false
//            halifax.drive = true
//        }
    }
}

