import UIKit

class BankShowViewController: UIViewController {
    var bank = BankLogin()
    var driver: WebViewDriver { return DriverManager.sharedInstance.driverForBank(bank) }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(driver.webView)
        title = bank.username
        sizeWebView()
    }

    // Probably should use constraints here...
    func sizeWebView() {
        let top = CGFloat(0)
        let height = self.view.frame.height - top
        driver.webView.frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: height)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        sizeWebView()
    }

}
