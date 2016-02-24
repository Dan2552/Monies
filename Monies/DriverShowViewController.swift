import UIKit

class DriverShowViewController: UIViewController {
    var bank = Bank()

    let halifax = (UIApplication.sharedApplication().delegate as! AppDelegate).halifax

    override func viewDidLoad() {
        view.addSubview(halifax.webview)
        title = bank.username
        sizeWebView()
    }

    // Probably should use constraints here...
    func sizeWebView() {
        let top = CGFloat(0)
        let height = self.view.frame.height - top
        halifax.webview.frame = CGRect(x: 0, y: top, width: self.view.frame.width, height: height)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        sizeWebView()
    }

}
