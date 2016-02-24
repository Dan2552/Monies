import UIKit
import XLForm
import Luncheon
import Napkin

class BankFormViewController: NapkinViewController {
    var login = Bank()
    
    override func saveWasTapped() {
        if login.create() {
            super.saveWasTapped()
        } else {
            let alert = UIAlertController(title: nil, message: "Fill in all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func setValuesToSubject() {
        try! login.r.write { super.setValuesToSubject() }
    }
    override func subject() -> Lunch {
        return self.login
    }
    
    override func setupFields() {
        input("username")
        input("password", type: .Password)
        input("memorableInformation", type: .Password)
    }
}