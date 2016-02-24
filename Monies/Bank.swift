import RealmSwift
import Luncheon

class Bank: Object, Lunch {
    //has_many :accounts

    dynamic var username = ""
    dynamic var password = ""
    dynamic var memorableInformation = ""
    
    lazy var r = try! Realm()
    
    func isValid() -> Bool {
        return username.characters.count > 0 && password.characters.count > 0 && memorableInformation.characters.count > 0
    }
    
    func create() -> Bool {
        if !isValid() { return false }
        try! r.write { self.r.add(self) }
        return true
    }

    class func existing() -> Bank? {
        return self.init().r.objects(self).first
    }
}