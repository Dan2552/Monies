import RealmSwift

class DriverManager {
    static let sharedInstance = DriverManager()

    var drivers = [String: WebViewDriver]()
    lazy var realm = try! Realm()

    func refreshAccounts() {
        let banks = realm.objects(BankLogin.self)

        for bank in banks {
            setDriverFlowsForBank(bank)
        }

        for (_, driver) in drivers {
            driver.executeFlows()
        }
    }

    func driverForBank(_ bank: BankLogin) -> WebViewDriver {
        if !drivers.keys.contains(bank.uuid) {
            drivers[bank.uuid] = WebViewDriver()
        }

        return drivers[bank.uuid]!
    }

    func setDriverFlowsForBank(_ bank: BankLogin) {
        let driver = driverForBank(bank)
        driver.activeFlows.removeAll()

        switch bank.bank {
        case 0: // halifax
            driver.activeFlows = [
                HalifaxLoginFlow(driver: driver, dataSource: bank),
                HalifaxAccountsOverviewFlow(driver: driver)
            ]
        default:
            break
        }
    }

}
