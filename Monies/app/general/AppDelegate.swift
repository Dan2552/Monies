import UIKit
import WebKit
import Placemat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    let driverManager = DriverManager.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Style().setGlobalTheme()
        NavigationFlow().presentLockscreen()
        return true
    }
}
