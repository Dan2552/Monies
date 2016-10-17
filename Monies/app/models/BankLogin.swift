import RealmSwift
import Luncheon

class BankLogin: Object, Lunch, HalifaxLoginFlowDataSource {
    //has_many :bank_accounts

    static let availableBanks = [
        0: "Halifax"
    ]

    dynamic var username = ""
    dynamic var password = ""
    dynamic var memorableInformation = ""
    dynamic var bank = 0
    dynamic var uuid = NSUUID().UUIDString

    lazy var r = try! Realm()
    
    func isValid() -> Bool {
        return username.characters.count > 0 && password.characters.count > 0 && memorableInformation.characters.count > 0
    }
    
    func create() -> Bool {
        if !isValid() { return false }
        try! r.write { self.r.add(self) }
        return true
    }

    class func existing() -> Bool {
        return self.init().r.objects(self).count > 0
    }

    func halifaxLoginUsername() -> String {
        return username
    }

    func halifaxLoginPassword() -> String {
        return password
    }

    func halifaxLoginMemorableInformation() -> String {
        return memorableInformation
    }
}