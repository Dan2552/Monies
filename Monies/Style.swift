import UIKit
import ChameleonFramework

class TintColorLabel: UILabel {}
class MinorDetailLabel: UILabel {}

class Style {
    func set() {
        Chameleon.setGlobalThemeUsingPrimaryColor(FlatYellow(),
                                                  withSecondaryColor: UIColor.whiteColor(),
                                                  andContentStyle: .Contrast)
    }

}