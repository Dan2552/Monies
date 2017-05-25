import UIKit
import Luncheon
import Napkin

class BankLoginEditViewController: EditViewController {
    var bankLogin = BankLogin()
    
    override func saveWasTapped() {
        if bankLogin.create() {
            super.saveWasTapped()
        } else {
            let alert = UIAlertController(title: nil, message: "Fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    override func setValuesToSubject() {
        try! bankLogin.r.write { super.setValuesToSubject() }
    }
    override func subject() -> Lunch {
        return bankLogin
    }
    
    override func setupFields() {
        input("bank", collection: BankLogin.availableBanks)
        
        sectionSeparator(header: "Credentials")
        
        input("username")
        input("password", type: .password)
        
        sectionSeparator(header: "Memorable Information",
                         footer: "The passphrase that you enter information when logging in where it says things like \"Please enter characters 2, 3 and 6 from your memorable information\".")
        
        input("memorableInformation", type: .password)
    }
}
