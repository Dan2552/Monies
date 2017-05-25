import UIKit
import ChameleonFramework

class TintColorLabel: UILabel {}
class MinorDetailLabel: UILabel {}

enum StyleTextSize: Int {
    case small = 10
    case normal = 16
    case large = 26
}

class Style {
    let fontName = "HelveticaNeue-Light"
    let primaryColor = FlatPlum()
    let secondaryColor = UIColor.white
    
    func setGlobalTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryColor,
                                                  withSecondaryColor: secondaryColor,
                                                  usingFontName: fontName,
                                                  andContentStyle: .contrast)
    }

    func font(size: StyleTextSize) -> UIFont {
        return UIFont(name: fontName, size: CGFloat(size.rawValue))!
    }
}
