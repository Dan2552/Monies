import UIKit
import WebKit
import Placemat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    let driverManager = DriverManager.sharedInstance
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Style().setGlobalTheme()
        NavigationFlow().presentLockscreen()
        return true
    }
}