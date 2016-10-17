import UIKit
import PureLayout
import Placemat

class BankLoginShowViewController: UIViewController {
    var bankLogin = BankLogin()
    var driver: WebViewDriver { return DriverManager.sharedInstance.driverForBank(bankLogin) }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = BlockBarButtonItem(barButtonSystemItem: .Edit) {
            NavigationFlow().presentEditBankLogin(from: self, bankLogin: self.bankLogin)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        title = bankLogin.username
        setupWebView()
    }
    
    private func setupWebView() {
        let webView = driver.webView
        guard webView.superview != view else { return }
        
        view.addSubview(webView)
        webView.autoPinEdgeToSuperviewEdge(.Top)
        webView.autoPinEdgeToSuperviewEdge(.Right)
        webView.autoPinEdgeToSuperviewEdge(.Left)
        webView.autoPinEdgeToSuperviewEdge(.Bottom)
    }
}