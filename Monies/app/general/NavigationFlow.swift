import UIKit
import Placemat

class NavigationFlow {
    func presentLockscreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = try! Navigation(viewController: LockViewController()).setupWindow()
    }
    
    func presentMainScreen(from current: LockViewController) {
        let accounts = BankAccountIndexViewController()
        accounts.title = "Overview"
        let tab1 = embedInNavigationController(accounts)
        tab1.tabBarItem.title = "Overview"
        tab1.tabBarItem.image = UIImage(named: "money_box-50")
        
        let banks = BankLoginIndexViewController()
        banks.title = "Banks"
        let tab2 = embedInNavigationController(banks)
        tab2.tabBarItem.title = "Banks"
        tab2.tabBarItem.image = UIImage(named: "safe-50")
        
        let tabs = UITabBarController()
        tabs.viewControllers = [tab1, tab2]
        
        Navigation(viewController: current).show(target: tabs)
    }
    
    func presentEditBankLogin(from current: UIViewController, bankLogin: BankLogin? = nil) {
        let target = BankLoginEditViewController()
        target.bankLogin = bankLogin ?? target.bankLogin
        Navigation(viewController: current).show(target: target, modally: true)
    }
    
    func presentBankLogin(from current: UIViewController, bankLogin: BankLogin) {
        let target = BankLoginShowViewController()
        target.bankLogin = bankLogin
        Navigation(viewController: current).show(target: target)
    }
    
    private func embedInNavigationController(_ viewController: UIViewController) -> UIViewController {
        let navigation = UINavigationController()
        navigation.viewControllers = [viewController]
        return navigation
    }
}
