import UIKit
import PureLayout
import Placemat

class BankLoginShowViewController: UIViewController {
    var bankLogin = BankLogin()
    var driver: WebViewDriver { return DriverManager.sharedInstance.driverForBank(bankLogin) }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = BlockBarButtonItem(barButtonSystemItem: .edit) {
            NavigationFlow().presentEditBankLogin(from: self, bankLogin: self.bankLogin)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = bankLogin.username
        setupWebView()
    }
    
    private func setupWebView() {
        let webView = driver.webView
        guard webView.superview != view else { return }
        
        webView.removeFromSuperview()
        view.addSubview(webView)
        
        webView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        webView.autoPin(toBottomLayoutGuideOf: self, withInset: 0)
        webView.autoPinEdge(toSuperviewEdge: .right)
        webView.autoPinEdge(toSuperviewEdge: .left)
    }
}
