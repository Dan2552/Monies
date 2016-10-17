import UIKit
import ChameleonFramework

class TintColorLabel: UILabel {}
class MinorDetailLabel: UILabel {}

enum StyleTextSize: Int {
    case Small = 10
    case Normal = 16
    case Large = 26
}

class Style {
    let fontName = "HelveticaNeue-Light"
    let primaryColor = FlatPlum()
    let secondaryColor = UIColor.whiteColor()
    
    func setGlobalTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryColor,
                                                  withSecondaryColor: secondaryColor,
                                                  usingFontName: fontName,
                                                  andContentStyle: .Contrast)
    }

    func font(size: StyleTextSize) -> UIFont {
        return UIFont(name: fontName, size: CGFloat(size.rawValue))!
    }
}