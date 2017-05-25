import UIKit
import LocalAuthentication
import Async
import Placemat

class LockViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = Style().primaryColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard ensureHasAccounts() else { return }
        touchId()
    }
    
    func touchId() {
        let context = LAContext()
        var error: NSError?
        let myLocalizedReasonString = "Identify"
        
        // Allow devices without TouchID
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            allow()
            return
        }
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, error in
            if success {
                Async.main(after: 0) { self.allow() }
            } else {
                Async.main(after: 5) { self.touchId() }
            }
        }
    }
    
    func allow() {
        NavigationFlow().presentMainScreen(from: self)
    }
    
    func ensureHasAccounts() -> Bool {
        if BankLogin.existing() { return true }
        NavigationFlow().presentEditBankLogin(from: self)
        return false
    }
}
